// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriveModel _$DriveModelFromJson(Map<String, dynamic> json) => _DriveModel(
  id: json['id'] as String,
  name: json['name'] as String,
  path: json['path'] as String,
  totalSpace: (json['totalSpace'] as num).toInt(),
  usedSpace: (json['usedSpace'] as num).toInt(),
  isRemovable: json['isRemovable'] as bool,
  mountPoint: json['mountPoint'] as String,
  type: $enumDecode(_$DriveTypeEnumMap, json['type']),
  isSelected: json['isSelected'] as bool,
  vendor: json['vendor'] as String?,
  model: json['model'] as String?,
  serialNumber: json['serialNumber'] as String?,
  partitionCount: (json['partitionCount'] as num?)?.toInt(),
  isMounted: json['isMounted'] as bool?,
);

Map<String, dynamic> _$DriveModelToJson(_DriveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'totalSpace': instance.totalSpace,
      'usedSpace': instance.usedSpace,
      'isRemovable': instance.isRemovable,
      'mountPoint': instance.mountPoint,
      'type': _$DriveTypeEnumMap[instance.type]!,
      'isSelected': instance.isSelected,
      'vendor': instance.vendor,
      'model': instance.model,
      'serialNumber': instance.serialNumber,
      'partitionCount': instance.partitionCount,
      'isMounted': instance.isMounted,
    };

const _$DriveTypeEnumMap = {
  DriveType.usb: 'usb',
  DriveType.sdCard: 'sdCard',
  DriveType.internal: 'internal',
  DriveType.dvd: 'dvd',
  DriveType.unknown: 'unknown',
};
