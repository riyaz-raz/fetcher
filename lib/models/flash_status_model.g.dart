// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlashStatusModel _$FlashStatusModelFromJson(Map<String, dynamic> json) =>
    _FlashStatusModel(
      state: $enumDecode(_$FlashStateEnumMap, json['state']),
      progress: (json['progress'] as num).toDouble(),
      bytesWritten: (json['bytesWritten'] as num).toInt(),
      totalBytes: (json['totalBytes'] as num).toInt(),
      writeSpeed: (json['writeSpeed'] as num).toInt(),
      currentStage: json['currentStage'] as String,
      isPaused: json['isPaused'] as bool,
      isCancelled: json['isCancelled'] as bool,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      errorMessage: json['errorMessage'] as String?,
      estimatedTimeRemaining: (json['estimatedTimeRemaining'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FlashStatusModelToJson(_FlashStatusModel instance) =>
    <String, dynamic>{
      'state': _$FlashStateEnumMap[instance.state]!,
      'progress': instance.progress,
      'bytesWritten': instance.bytesWritten,
      'totalBytes': instance.totalBytes,
      'writeSpeed': instance.writeSpeed,
      'currentStage': instance.currentStage,
      'isPaused': instance.isPaused,
      'isCancelled': instance.isCancelled,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'errorMessage': instance.errorMessage,
      'estimatedTimeRemaining': instance.estimatedTimeRemaining,
    };

const _$FlashStateEnumMap = {
  FlashState.idle: 'idle',
  FlashState.preparing: 'preparing',
  FlashState.writing: 'writing',
  FlashState.verifying: 'verifying',
  FlashState.completed: 'completed',
  FlashState.failed: 'failed',
  FlashState.cancelled: 'cancelled',
  FlashState.paused: 'paused',
};
