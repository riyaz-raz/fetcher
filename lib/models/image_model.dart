import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

@freezed
abstract class ImageModel with _$ImageModel {
  const factory ImageModel({
    required String id,
    required String name,
    required String path,
    required int size,
    required ImageType type,
    required String fileExtension,
    required DateTime dateAdded,
    String? md5Checksum,
    String? sha256Checksum,
    bool? isValid,
    bool? isCompressed,
    String? compressionType,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}

enum ImageType { iso, img, dmg, bin, raw, gz, xz, other }

extension ImageTypeExtension on ImageType {
  String get displayName {
    switch (this) {
      case ImageType.iso:
        return 'ISO';
      case ImageType.img:
        return 'IMG';
      case ImageType.dmg:
        return 'DMG';
      case ImageType.bin:
        return 'BIN';
      case ImageType.raw:
        return 'RAW';
      case ImageType.gz:
        return 'GZ';
      case ImageType.xz:
        return 'XZ';
      case ImageType.other:
        return 'Other';
    }
  }

  static ImageType fromExtension(String extension) {
    final ext = extension.toLowerCase();
    switch (ext) {
      case 'iso':
        return ImageType.iso;
      case 'img':
      case 'ima':
        return ImageType.img;
      case 'dmg':
        return ImageType.dmg;
      case 'bin':
        return ImageType.bin;
      case 'raw':
        return ImageType.raw;
      case 'gz':
        return ImageType.gz;
      case 'xz':
        return ImageType.xz;
      default:
        return ImageType.other;
    }
  }
}

extension ImageModelExtension on ImageModel {
  String get formattedSize => _formatSize(size);

  bool get isLargeImage => size > 4 * 1024 * 1024 * 1024; // > 4GB

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
