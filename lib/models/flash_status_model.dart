import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_status_model.freezed.dart';
part 'flash_status_model.g.dart';

@freezed
abstract class FlashStatusModel with _$FlashStatusModel {
  const factory FlashStatusModel({
    required FlashState state,
    required double progress,
    required int bytesWritten,
    required int totalBytes,
    required int writeSpeed,
    required String currentStage,
    required bool isPaused,
    required bool isCancelled,
    required DateTime startTime,
    DateTime? endTime,
    String? errorMessage,
    int? estimatedTimeRemaining,
  }) = _FlashStatusModel;

  factory FlashStatusModel.initial() => FlashStatusModel(
    state: FlashState.idle,
    progress: 0.0,
    bytesWritten: 0,
    totalBytes: 0,
    writeSpeed: 0,
    currentStage: 'Ready',
    isPaused: false,
    isCancelled: false,
    startTime: DateTime.now(), // Will be overridden in code
  );

  factory FlashStatusModel.fromJson(Map<String, dynamic> json) =>
      _$FlashStatusModelFromJson(json);
}

enum FlashState {
  idle,
  preparing,
  writing,
  verifying,
  completed,
  failed,
  cancelled,
  paused,
}

extension FlashStatusModelExtension on FlashStatusModel {
  bool get isInProgress =>
      state == FlashState.writing ||
      state == FlashState.preparing ||
      state == FlashState.verifying;

  bool get isCompleted => state == FlashState.completed;
  bool get isFailed => state == FlashState.failed;
  bool get isCancelledState => state == FlashState.cancelled;
  bool get isPausedState => state == FlashState.paused;

  String get timeElapsed {
    final now = DateTime.now();
    final duration = now.difference(startTime);
    return _formatDuration(duration);
  }

  String get formattedProgress => '${(progress * 100).round()}%';

  String get formattedBytesWritten => _formatSize(bytesWritten);
  String get formattedTotalBytes => _formatSize(totalBytes);

  String get formattedSpeed {
    if (writeSpeed < 1024) return '${writeSpeed} B/s';
    if (writeSpeed < 1024 * 1024) {
      return '${(writeSpeed / 1024).toStringAsFixed(1)} KB/s';
    }
    if (writeSpeed < 1024 * 1024 * 1024) {
      return '${(writeSpeed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    return '${(writeSpeed / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB/s';
  }

  String get estimatedTimeRemaining {
    if (progress <= 0 || writeSpeed <= 0) return 'Calculating...';
    final remainingBytes = totalBytes - bytesWritten;
    final secondsRemaining = remainingBytes / writeSpeed;
    return _formatDuration(Duration(seconds: secondsRemaining.toInt()));
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
