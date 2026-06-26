// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flash_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlashStatusModel {

 FlashState get state; double get progress; int get bytesWritten; int get totalBytes; int get writeSpeed; String get currentStage; bool get isPaused; bool get isCancelled; DateTime get startTime; DateTime? get endTime; String? get errorMessage; int? get estimatedTimeRemaining;
/// Create a copy of FlashStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashStatusModelCopyWith<FlashStatusModel> get copyWith => _$FlashStatusModelCopyWithImpl<FlashStatusModel>(this as FlashStatusModel, _$identity);

  /// Serializes this FlashStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashStatusModel&&(identical(other.state, state) || other.state == state)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.bytesWritten, bytesWritten) || other.bytesWritten == bytesWritten)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.writeSpeed, writeSpeed) || other.writeSpeed == writeSpeed)&&(identical(other.currentStage, currentStage) || other.currentStage == currentStage)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.estimatedTimeRemaining, estimatedTimeRemaining) || other.estimatedTimeRemaining == estimatedTimeRemaining));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,progress,bytesWritten,totalBytes,writeSpeed,currentStage,isPaused,isCancelled,startTime,endTime,errorMessage,estimatedTimeRemaining);

@override
String toString() {
  return 'FlashStatusModel(state: $state, progress: $progress, bytesWritten: $bytesWritten, totalBytes: $totalBytes, writeSpeed: $writeSpeed, currentStage: $currentStage, isPaused: $isPaused, isCancelled: $isCancelled, startTime: $startTime, endTime: $endTime, errorMessage: $errorMessage, estimatedTimeRemaining: $estimatedTimeRemaining)';
}


}

/// @nodoc
abstract mixin class $FlashStatusModelCopyWith<$Res>  {
  factory $FlashStatusModelCopyWith(FlashStatusModel value, $Res Function(FlashStatusModel) _then) = _$FlashStatusModelCopyWithImpl;
@useResult
$Res call({
 FlashState state, double progress, int bytesWritten, int totalBytes, int writeSpeed, String currentStage, bool isPaused, bool isCancelled, DateTime startTime, DateTime? endTime, String? errorMessage, int? estimatedTimeRemaining
});




}
/// @nodoc
class _$FlashStatusModelCopyWithImpl<$Res>
    implements $FlashStatusModelCopyWith<$Res> {
  _$FlashStatusModelCopyWithImpl(this._self, this._then);

  final FlashStatusModel _self;
  final $Res Function(FlashStatusModel) _then;

/// Create a copy of FlashStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? progress = null,Object? bytesWritten = null,Object? totalBytes = null,Object? writeSpeed = null,Object? currentStage = null,Object? isPaused = null,Object? isCancelled = null,Object? startTime = null,Object? endTime = freezed,Object? errorMessage = freezed,Object? estimatedTimeRemaining = freezed,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as FlashState,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,bytesWritten: null == bytesWritten ? _self.bytesWritten : bytesWritten // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,writeSpeed: null == writeSpeed ? _self.writeSpeed : writeSpeed // ignore: cast_nullable_to_non_nullable
as int,currentStage: null == currentStage ? _self.currentStage : currentStage // ignore: cast_nullable_to_non_nullable
as String,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,estimatedTimeRemaining: freezed == estimatedTimeRemaining ? _self.estimatedTimeRemaining : estimatedTimeRemaining // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashStatusModel].
extension FlashStatusModelPatterns on FlashStatusModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashStatusModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _FlashStatusModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _FlashStatusModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlashState state,  double progress,  int bytesWritten,  int totalBytes,  int writeSpeed,  String currentStage,  bool isPaused,  bool isCancelled,  DateTime startTime,  DateTime? endTime,  String? errorMessage,  int? estimatedTimeRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashStatusModel() when $default != null:
return $default(_that.state,_that.progress,_that.bytesWritten,_that.totalBytes,_that.writeSpeed,_that.currentStage,_that.isPaused,_that.isCancelled,_that.startTime,_that.endTime,_that.errorMessage,_that.estimatedTimeRemaining);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlashState state,  double progress,  int bytesWritten,  int totalBytes,  int writeSpeed,  String currentStage,  bool isPaused,  bool isCancelled,  DateTime startTime,  DateTime? endTime,  String? errorMessage,  int? estimatedTimeRemaining)  $default,) {final _that = this;
switch (_that) {
case _FlashStatusModel():
return $default(_that.state,_that.progress,_that.bytesWritten,_that.totalBytes,_that.writeSpeed,_that.currentStage,_that.isPaused,_that.isCancelled,_that.startTime,_that.endTime,_that.errorMessage,_that.estimatedTimeRemaining);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlashState state,  double progress,  int bytesWritten,  int totalBytes,  int writeSpeed,  String currentStage,  bool isPaused,  bool isCancelled,  DateTime startTime,  DateTime? endTime,  String? errorMessage,  int? estimatedTimeRemaining)?  $default,) {final _that = this;
switch (_that) {
case _FlashStatusModel() when $default != null:
return $default(_that.state,_that.progress,_that.bytesWritten,_that.totalBytes,_that.writeSpeed,_that.currentStage,_that.isPaused,_that.isCancelled,_that.startTime,_that.endTime,_that.errorMessage,_that.estimatedTimeRemaining);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlashStatusModel implements FlashStatusModel {
  const _FlashStatusModel({required this.state, required this.progress, required this.bytesWritten, required this.totalBytes, required this.writeSpeed, required this.currentStage, required this.isPaused, required this.isCancelled, required this.startTime, this.endTime, this.errorMessage, this.estimatedTimeRemaining});
  factory _FlashStatusModel.fromJson(Map<String, dynamic> json) => _$FlashStatusModelFromJson(json);

@override final  FlashState state;
@override final  double progress;
@override final  int bytesWritten;
@override final  int totalBytes;
@override final  int writeSpeed;
@override final  String currentStage;
@override final  bool isPaused;
@override final  bool isCancelled;
@override final  DateTime startTime;
@override final  DateTime? endTime;
@override final  String? errorMessage;
@override final  int? estimatedTimeRemaining;

/// Create a copy of FlashStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashStatusModelCopyWith<_FlashStatusModel> get copyWith => __$FlashStatusModelCopyWithImpl<_FlashStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashStatusModel&&(identical(other.state, state) || other.state == state)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.bytesWritten, bytesWritten) || other.bytesWritten == bytesWritten)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.writeSpeed, writeSpeed) || other.writeSpeed == writeSpeed)&&(identical(other.currentStage, currentStage) || other.currentStage == currentStage)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.estimatedTimeRemaining, estimatedTimeRemaining) || other.estimatedTimeRemaining == estimatedTimeRemaining));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,progress,bytesWritten,totalBytes,writeSpeed,currentStage,isPaused,isCancelled,startTime,endTime,errorMessage,estimatedTimeRemaining);

@override
String toString() {
  return 'FlashStatusModel(state: $state, progress: $progress, bytesWritten: $bytesWritten, totalBytes: $totalBytes, writeSpeed: $writeSpeed, currentStage: $currentStage, isPaused: $isPaused, isCancelled: $isCancelled, startTime: $startTime, endTime: $endTime, errorMessage: $errorMessage, estimatedTimeRemaining: $estimatedTimeRemaining)';
}


}

/// @nodoc
abstract mixin class _$FlashStatusModelCopyWith<$Res> implements $FlashStatusModelCopyWith<$Res> {
  factory _$FlashStatusModelCopyWith(_FlashStatusModel value, $Res Function(_FlashStatusModel) _then) = __$FlashStatusModelCopyWithImpl;
@override @useResult
$Res call({
 FlashState state, double progress, int bytesWritten, int totalBytes, int writeSpeed, String currentStage, bool isPaused, bool isCancelled, DateTime startTime, DateTime? endTime, String? errorMessage, int? estimatedTimeRemaining
});




}
/// @nodoc
class __$FlashStatusModelCopyWithImpl<$Res>
    implements _$FlashStatusModelCopyWith<$Res> {
  __$FlashStatusModelCopyWithImpl(this._self, this._then);

  final _FlashStatusModel _self;
  final $Res Function(_FlashStatusModel) _then;

/// Create a copy of FlashStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? progress = null,Object? bytesWritten = null,Object? totalBytes = null,Object? writeSpeed = null,Object? currentStage = null,Object? isPaused = null,Object? isCancelled = null,Object? startTime = null,Object? endTime = freezed,Object? errorMessage = freezed,Object? estimatedTimeRemaining = freezed,}) {
  return _then(_FlashStatusModel(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as FlashState,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,bytesWritten: null == bytesWritten ? _self.bytesWritten : bytesWritten // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,writeSpeed: null == writeSpeed ? _self.writeSpeed : writeSpeed // ignore: cast_nullable_to_non_nullable
as int,currentStage: null == currentStage ? _self.currentStage : currentStage // ignore: cast_nullable_to_non_nullable
as String,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,estimatedTimeRemaining: freezed == estimatedTimeRemaining ? _self.estimatedTimeRemaining : estimatedTimeRemaining // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
