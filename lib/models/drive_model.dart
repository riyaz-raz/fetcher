import 'package:freezed_annotation/freezed_annotation.dart';

part 'drive_model.freezed.dart';
part 'drive_model.g.dart';

@freezed
abstract class DriveModel with _$DriveModel {
  const factory DriveModel({
    required String id,
    required String name,
    required String path,
    required int totalSpace,
    required int usedSpace,
    required bool isRemovable,
    required String mountPoint,
    required DriveType type,
    required bool isSelected,
    String? vendor,
    String? model,
    String? serialNumber,
    int? partitionCount,
    bool? isMounted,
  }) = _DriveModel;

  factory DriveModel.fromJson(Map<String, dynamic> json) =>
      _$DriveModelFromJson(json);
}

enum DriveType { usb, sdCard, internal, dvd, unknown }

extension DriveModelExtension on DriveModel {
  int get freeSpace => totalSpace - usedSpace;

  double get usedPercentage {
    if (totalSpace == 0) return 0.0;
    return usedSpace / totalSpace;
  }

  String get formattedFreeSpace => _formatSize(freeSpace);
  String get formattedTotalSpace => _formatSize(totalSpace);
  String get formattedUsedSpace => _formatSize(usedSpace);

  bool get isWritable =>
      type != DriveType.dvd && type != DriveType.unknown && isMounted != false;

  bool hasEnoughSpace(int imageSize) => freeSpace >= imageSize;

  String get driveIcon {
    switch (type) {
      case DriveType.usb:
        return 'USB';
      case DriveType.sdCard:
        return 'SD';
      case DriveType.dvd:
        return 'DVD';
      default:
        return 'HDD';
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
