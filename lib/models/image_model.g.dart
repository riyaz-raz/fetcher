// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => _ImageModel(
  id: json['id'] as String,
  name: json['name'] as String,
  path: json['path'] as String,
  size: (json['size'] as num).toInt(),
  type: $enumDecode(_$ImageTypeEnumMap, json['type']),
  fileExtension: json['fileExtension'] as String,
  dateAdded: DateTime.parse(json['dateAdded'] as String),
  md5Checksum: json['md5Checksum'] as String?,
  sha256Checksum: json['sha256Checksum'] as String?,
  isValid: json['isValid'] as bool?,
  isCompressed: json['isCompressed'] as bool?,
  compressionType: json['compressionType'] as String?,
);

Map<String, dynamic> _$ImageModelToJson(_ImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'size': instance.size,
      'type': _$ImageTypeEnumMap[instance.type]!,
      'fileExtension': instance.fileExtension,
      'dateAdded': instance.dateAdded.toIso8601String(),
      'md5Checksum': instance.md5Checksum,
      'sha256Checksum': instance.sha256Checksum,
      'isValid': instance.isValid,
      'isCompressed': instance.isCompressed,
      'compressionType': instance.compressionType,
    };

const _$ImageTypeEnumMap = {
  ImageType.iso: 'iso',
  ImageType.img: 'img',
  ImageType.dmg: 'dmg',
  ImageType.bin: 'bin',
  ImageType.raw: 'raw',
  ImageType.gz: 'gz',
  ImageType.xz: 'xz',
  ImageType.other: 'other',
};
