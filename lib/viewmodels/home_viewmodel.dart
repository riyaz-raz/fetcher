import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/services/usb_service.dart';
import '../core/services/image_service.dart';
import '../core/services/flash_service.dart';
import '../models/drive_model.dart';
import '../models/image_model.dart';
import '../models/flash_status_model.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel(
    usbService: UsbService(),
    imageService: ImageService(),
    flashService: FlashService(),
  );
});

class HomeViewModel extends StateNotifier<HomeState> {
  final UsbService _usbService;
  final ImageService _imageService;
  final FlashService _flashService;

  HomeViewModel({
    required UsbService usbService,
    required ImageService imageService,
    required FlashService flashService,
  }) : _usbService = usbService,
       _imageService = imageService,
       _flashService = flashService,
       super(const HomeState.initial()) {
    // Listen to flash status updates
    _flashService.statusStream.listen((status) {
      state = state.copyWith(flashStatus: status);
      if (status.state == FlashState.completed ||
          status.state == FlashState.failed ||
          status.state == FlashState.cancelled) {
        state = state.copyWith(isFlashing: false);
      }
    });
  }

  Future<void> loadDrives() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final drives = await _usbService.getAvailableDrives();
      state = state.copyWith(drives: drives, isLoading: false, error: null);
      await _validateSelection();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load drives: $e',
      );
    }
  }

  Future<void> selectImage() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final image = await _imageService.selectImage();
      if (image != null) {
        state = state.copyWith(selectedImage: image);
        await _validateSelection();
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to select image: $e',
      );
    }
  }

  Future<void> selectDrive(DriveModel drive) async {
    try {
      state = state.copyWith(selectedDrive: drive, error: null);
      await _validateSelection();
    } catch (e) {
      state = state.copyWith(error: 'Failed to select drive: $e');
    }
  }

  Future<void> _validateSelection() async {
    final image = state.selectedImage;
    final drive = state.selectedDrive;

    if (image != null && drive != null) {
      final isValid = await _usbService.validateDrive(drive, image.size);
      state = state.copyWith(
        isValidSelection: isValid,
        validationMessage: isValid
            ? '✅ Ready to flash: ${drive.name} has enough space'
            : '❌ Drive does not have enough space or is not writable',
      );
    } else if (image != null && drive == null) {
      state = state.copyWith(
        isValidSelection: false,
        validationMessage: 'Please select a drive',
      );
    } else if (image == null && drive != null) {
      state = state.copyWith(
        isValidSelection: false,
        validationMessage: 'Please select an image',
      );
    } else {
      state = state.copyWith(
        isValidSelection: false,
        validationMessage: 'Select an image and a drive to begin',
      );
    }
  }

  Future<void> startFlashing() async {
    if (state.selectedImage != null && state.selectedDrive != null) {
      if (!state.isValidSelection) {
        state = state.copyWith(
          error: 'Cannot start flashing: Invalid selection',
        );
        return;
      }

      state = state.copyWith(isFlashing: true, error: null);

      try {
        await _flashService.flashImage(
          state.selectedImage!,
          state.selectedDrive!,
        );
      } catch (e) {
        state = state.copyWith(error: 'Flashing failed: $e', isFlashing: false);
      }
    }
  }

  void pauseFlashing() {
    if (_flashService.isFlashing && !_flashService.isPaused) {
      _flashService.pause();
    }
  }

  void resumeFlashing() {
    if (_flashService.isFlashing && _flashService.isPaused) {
      _flashService.resume();
    }
  }

  void cancelFlashing() {
    if (_flashService.isFlashing) {
      _flashService.cancel();
    }
  }

  void refreshDrives() {
    loadDrives();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _flashService.dispose();
    super.dispose();
  }
}

class HomeState extends Equatable {
  final List<DriveModel> drives;
  final ImageModel? selectedImage;
  final DriveModel? selectedDrive;
  final bool isLoading;
  final bool isFlashing;
  final bool isValidSelection;
  final String? validationMessage;
  final String? error;
  final FlashStatusModel? flashStatus;

  const HomeState({
    this.drives = const [],
    this.selectedImage,
    this.selectedDrive,
    this.isLoading = false,
    this.isFlashing = false,
    this.isValidSelection = false,
    this.validationMessage,
    this.error,
    this.flashStatus,
  });

  const HomeState.initial() : this();

  HomeState copyWith({
    List<DriveModel>? drives,
    ImageModel? selectedImage,
    DriveModel? selectedDrive,
    bool? isLoading,
    bool? isFlashing,
    bool? isValidSelection,
    String? validationMessage,
    String? error,
    FlashStatusModel? flashStatus,
  }) {
    return HomeState(
      drives: drives ?? this.drives,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedDrive: selectedDrive ?? this.selectedDrive,
      isLoading: isLoading ?? this.isLoading,
      isFlashing: isFlashing ?? this.isFlashing,
      isValidSelection: isValidSelection ?? this.isValidSelection,
      validationMessage: validationMessage ?? this.validationMessage,
      error: error ?? this.error,
      flashStatus: flashStatus ?? this.flashStatus,
    );
  }

  @override
  List<Object?> get props => [
    drives,
    selectedImage,
    selectedDrive,
    isLoading,
    isFlashing,
    isValidSelection,
    validationMessage,
    error,
    flashStatus,
  ];
}
