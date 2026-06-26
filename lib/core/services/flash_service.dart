import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:fetcher/core/services/usb_service.dart';
import 'package:synchronized/synchronized.dart';
import 'package:crypto/crypto.dart';
import '../../models/drive_model.dart';
import '../../models/flash_status_model.dart';
import '../../models/image_model.dart';

class FlashService {
  static final FlashService _instance = FlashService._internal();
  factory FlashService() => _instance;
  FlashService._internal();

  final Lock _lock = Lock();
  final StreamController<FlashStatusModel> _statusController =
      StreamController<FlashStatusModel>.broadcast();

  bool _isFlashing = false;
  bool _isPaused = false;
  bool _isCancelled = false;
  int _bytesWritten = 0;
  int _totalBytes = 0;
  Stopwatch? _stopwatch;
  late DateTime _startTime;

  Stream<FlashStatusModel> get statusStream => _statusController.stream;

  bool get isFlashing => _isFlashing;
  bool get isPaused => _isPaused;

  Future<void> flashImage(ImageModel image, DriveModel drive) async {
    if (_isFlashing) throw Exception('Already flashing');

    await _lock.synchronized(() async {
      _isFlashing = true;
      _isPaused = false;
      _isCancelled = false;
      _bytesWritten = 0;
      _totalBytes = await File(image.path).length();
      _startTime = DateTime.now();
      _stopwatch = Stopwatch()..start();

      try {
        // Phase 1: Preparing
        _updateStatus(FlashState.preparing, 0.0, stage: 'Preparing drive...');
        await _prepareDrive(drive);

        // Check if cancelled
        if (_isCancelled) {
          _updateStatus(FlashState.cancelled, 0.0, stage: 'Cancelled');
          return;
        }

        // Phase 2: Writing
        _updateStatus(FlashState.writing, 0.0, stage: 'Writing image...');
        await _writeImage(image, drive);

        // Check if cancelled
        if (_isCancelled) {
          _updateStatus(FlashState.cancelled, 0.0, stage: 'Cancelled');
          return;
        }

        // Phase 3: Verifying
        if (!_isCancelled) {
          _updateStatus(FlashState.verifying, 0.0, stage: 'Verifying write...');
          await _verifyWrite(image, drive);
        }

        // Phase 4: Complete
        if (!_isCancelled) {
          _updateStatus(FlashState.completed, 1.0, stage: 'Flash complete!');
        }
      } catch (e) {
        _updateStatus(
          FlashState.failed,
          _bytesWritten / _totalBytes,
          stage: 'Error: $e',
          errorMessage: e.toString(),
        );
        rethrow;
      } finally {
        _isFlashing = false;
        _stopwatch?.stop();
      }
    });
  }

  Future<void> _prepareDrive(DriveModel drive) async {
    // Unmount the drive
    await UsbService().unmountDrive(drive);

    // Check write permissions
    if (!drive.isWritable) {
      throw Exception('Drive is not writable');
    }

    // Small delay to ensure drive is ready
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _writeImage(ImageModel image, DriveModel drive) async {
    final imageFile = File(image.path);
    final targetPath = drive.path;

    // For Windows, use the drive letter directly
    // For Linux/macOS, use the device file
    final targetFile = Platform.isWindows
        ? File('\\\\.\\${targetPath[0]}:') // Windows raw disk access
        : File(targetPath);

    const bufferSize = 1024 * 1024 * 8; // 8MB buffer
    final buffer = Uint8List(bufferSize);
    int bytesWritten = 0;

    final inputStream = imageFile.openRead();
    final outputStream = targetFile.openWrite(mode: FileMode.writeOnlyAppend);

    try {
      await for (final chunk in inputStream) {
        // Check for pause
        while (_isPaused) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (_isCancelled) break;
        }

        // Check for cancellation
        if (_isCancelled) {
          throw Exception('Flashing cancelled');
        }

        // Write chunk
        outputStream.add(chunk);
        bytesWritten += chunk.length;
        _bytesWritten = bytesWritten;

        // Update progress
        final progress = bytesWritten / _totalBytes;
        final speed = _calculateWriteSpeed();
        _updateStatus(
          FlashState.writing,
          progress,
          stage: 'Writing... ${(progress * 100).round()}%',
          writeSpeed: speed,
        );
      }

      await outputStream.flush();
    } finally {
      await outputStream.close();
    }
  }

  Future<void> _verifyWrite(ImageModel image, DriveModel drive) async {
    try {
      // Calculate MD5 of source image
      final sourceMd5 = await _calculateFileMd5(image.path);

      // For verification, read back the written data
      final targetFile = Platform.isWindows
          ? File('\\\\.\\${drive.path[0]}:')
          : File(drive.path);

      final targetMd5 = await _calculateFileMd5(targetFile.path);

      if (sourceMd5 != targetMd5) {
        throw Exception('Verification failed: Checksum mismatch');
      }

      _updateStatus(
        FlashState.verifying,
        1.0,
        stage: 'Verification successful!',
      );
    } catch (e) {
      throw Exception('Verification error: $e');
    }
  }

  Future<String> _calculateFileMd5(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    return md5.convert(bytes).toString();
  }

  int _calculateWriteSpeed() {
    if (_stopwatch == null || _stopwatch!.elapsed.inSeconds == 0) {
      return 0;
    }
    return (_bytesWritten / _stopwatch!.elapsed.inSeconds).round();
  }

  void _updateStatus(
    FlashState state,
    double progress, {
    required String stage,
    int writeSpeed = 0,
    String? errorMessage,
  }) {
    final status = FlashStatusModel(
      state: state,
      progress: progress,
      bytesWritten: _bytesWritten,
      totalBytes: _totalBytes,
      writeSpeed: writeSpeed > 0 ? writeSpeed : _calculateWriteSpeed(),
      currentStage: stage,
      isPaused: _isPaused,
      isCancelled: _isCancelled,
      startTime: _startTime,
      endTime:
          state == FlashState.completed ||
              state == FlashState.failed ||
              state == FlashState.cancelled
          ? DateTime.now()
          : null,
      errorMessage: errorMessage,
    );
    _statusController.add(status);
  }

  Future<void> pause() async {
    if (_isFlashing && !_isPaused) {
      _isPaused = true;
      _updateStatus(
        FlashState.paused,
        _bytesWritten / _totalBytes,
        stage: 'Paused',
      );
    }
  }

  Future<void> resume() async {
    if (_isFlashing && _isPaused) {
      _isPaused = false;
      _stopwatch?.start();
      _updateStatus(
        FlashState.writing,
        _bytesWritten / _totalBytes,
        stage: 'Resuming...',
      );
    }
  }

  Future<void> cancel() async {
    if (_isFlashing) {
      _isCancelled = true;
      _updateStatus(
        FlashState.cancelled,
        _bytesWritten / _totalBytes,
        stage: 'Cancelled',
      );
    }
  }

  void dispose() {
    _statusController.close();
  }
}
