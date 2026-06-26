// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drive_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriveModel {

 String get id; String get name; String get path; int get totalSpace; int get usedSpace; bool get isRemovable; String get mountPoint; DriveType get type; bool get isSelected; String? get vendor; String? get model; String? get serialNumber; int? get partitionCount; bool? get isMounted;
/// Create a copy of DriveModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriveModelCopyWith<DriveModel> get copyWith => _$DriveModelCopyWithImpl<DriveModel>(this as DriveModel, _$identity);

  /// Serializes this DriveModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.totalSpace, totalSpace) || other.totalSpace == totalSpace)&&(identical(other.usedSpace, usedSpace) || other.usedSpace == usedSpace)&&(identical(other.isRemovable, isRemovable) || other.isRemovable == isRemovable)&&(identical(other.mountPoint, mountPoint) || other.mountPoint == mountPoint)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.partitionCount, partitionCount) || other.partitionCount == partitionCount)&&(identical(other.isMounted, isMounted) || other.isMounted == isMounted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,totalSpace,usedSpace,isRemovable,mountPoint,type,isSelected,vendor,model,serialNumber,partitionCount,isMounted);

@override
String toString() {
  return 'DriveModel(id: $id, name: $name, path: $path, totalSpace: $totalSpace, usedSpace: $usedSpace, isRemovable: $isRemovable, mountPoint: $mountPoint, type: $type, isSelected: $isSelected, vendor: $vendor, model: $model, serialNumber: $serialNumber, partitionCount: $partitionCount, isMounted: $isMounted)';
}


}

/// @nodoc
abstract mixin class $DriveModelCopyWith<$Res>  {
  factory $DriveModelCopyWith(DriveModel value, $Res Function(DriveModel) _then) = _$DriveModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String path, int totalSpace, int usedSpace, bool isRemovable, String mountPoint, DriveType type, bool isSelected, String? vendor, String? model, String? serialNumber, int? partitionCount, bool? isMounted
});




}
/// @nodoc
class _$DriveModelCopyWithImpl<$Res>
    implements $DriveModelCopyWith<$Res> {
  _$DriveModelCopyWithImpl(this._self, this._then);

  final DriveModel _self;
  final $Res Function(DriveModel) _then;

/// Create a copy of DriveModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? path = null,Object? totalSpace = null,Object? usedSpace = null,Object? isRemovable = null,Object? mountPoint = null,Object? type = null,Object? isSelected = null,Object? vendor = freezed,Object? model = freezed,Object? serialNumber = freezed,Object? partitionCount = freezed,Object? isMounted = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,totalSpace: null == totalSpace ? _self.totalSpace : totalSpace // ignore: cast_nullable_to_non_nullable
as int,usedSpace: null == usedSpace ? _self.usedSpace : usedSpace // ignore: cast_nullable_to_non_nullable
as int,isRemovable: null == isRemovable ? _self.isRemovable : isRemovable // ignore: cast_nullable_to_non_nullable
as bool,mountPoint: null == mountPoint ? _self.mountPoint : mountPoint // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DriveType,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,partitionCount: freezed == partitionCount ? _self.partitionCount : partitionCount // ignore: cast_nullable_to_non_nullable
as int?,isMounted: freezed == isMounted ? _self.isMounted : isMounted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DriveModel].
extension DriveModelPatterns on DriveModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriveModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriveModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriveModel value)  $default,){
final _that = this;
switch (_that) {
case _DriveModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriveModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriveModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String path,  int totalSpace,  int usedSpace,  bool isRemovable,  String mountPoint,  DriveType type,  bool isSelected,  String? vendor,  String? model,  String? serialNumber,  int? partitionCount,  bool? isMounted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriveModel() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.totalSpace,_that.usedSpace,_that.isRemovable,_that.mountPoint,_that.type,_that.isSelected,_that.vendor,_that.model,_that.serialNumber,_that.partitionCount,_that.isMounted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String path,  int totalSpace,  int usedSpace,  bool isRemovable,  String mountPoint,  DriveType type,  bool isSelected,  String? vendor,  String? model,  String? serialNumber,  int? partitionCount,  bool? isMounted)  $default,) {final _that = this;
switch (_that) {
case _DriveModel():
return $default(_that.id,_that.name,_that.path,_that.totalSpace,_that.usedSpace,_that.isRemovable,_that.mountPoint,_that.type,_that.isSelected,_that.vendor,_that.model,_that.serialNumber,_that.partitionCount,_that.isMounted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String path,  int totalSpace,  int usedSpace,  bool isRemovable,  String mountPoint,  DriveType type,  bool isSelected,  String? vendor,  String? model,  String? serialNumber,  int? partitionCount,  bool? isMounted)?  $default,) {final _that = this;
switch (_that) {
case _DriveModel() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.totalSpace,_that.usedSpace,_that.isRemovable,_that.mountPoint,_that.type,_that.isSelected,_that.vendor,_that.model,_that.serialNumber,_that.partitionCount,_that.isMounted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriveModel implements DriveModel {
  const _DriveModel({required this.id, required this.name, required this.path, required this.totalSpace, required this.usedSpace, required this.isRemovable, required this.mountPoint, required this.type, required this.isSelected, this.vendor, this.model, this.serialNumber, this.partitionCount, this.isMounted});
  factory _DriveModel.fromJson(Map<String, dynamic> json) => _$DriveModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String path;
@override final  int totalSpace;
@override final  int usedSpace;
@override final  bool isRemovable;
@override final  String mountPoint;
@override final  DriveType type;
@override final  bool isSelected;
@override final  String? vendor;
@override final  String? model;
@override final  String? serialNumber;
@override final  int? partitionCount;
@override final  bool? isMounted;

/// Create a copy of DriveModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriveModelCopyWith<_DriveModel> get copyWith => __$DriveModelCopyWithImpl<_DriveModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriveModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriveModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.totalSpace, totalSpace) || other.totalSpace == totalSpace)&&(identical(other.usedSpace, usedSpace) || other.usedSpace == usedSpace)&&(identical(other.isRemovable, isRemovable) || other.isRemovable == isRemovable)&&(identical(other.mountPoint, mountPoint) || other.mountPoint == mountPoint)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.partitionCount, partitionCount) || other.partitionCount == partitionCount)&&(identical(other.isMounted, isMounted) || other.isMounted == isMounted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,totalSpace,usedSpace,isRemovable,mountPoint,type,isSelected,vendor,model,serialNumber,partitionCount,isMounted);

@override
String toString() {
  return 'DriveModel(id: $id, name: $name, path: $path, totalSpace: $totalSpace, usedSpace: $usedSpace, isRemovable: $isRemovable, mountPoint: $mountPoint, type: $type, isSelected: $isSelected, vendor: $vendor, model: $model, serialNumber: $serialNumber, partitionCount: $partitionCount, isMounted: $isMounted)';
}


}

/// @nodoc
abstract mixin class _$DriveModelCopyWith<$Res> implements $DriveModelCopyWith<$Res> {
  factory _$DriveModelCopyWith(_DriveModel value, $Res Function(_DriveModel) _then) = __$DriveModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String path, int totalSpace, int usedSpace, bool isRemovable, String mountPoint, DriveType type, bool isSelected, String? vendor, String? model, String? serialNumber, int? partitionCount, bool? isMounted
});




}
/// @nodoc
class __$DriveModelCopyWithImpl<$Res>
    implements _$DriveModelCopyWith<$Res> {
  __$DriveModelCopyWithImpl(this._self, this._then);

  final _DriveModel _self;
  final $Res Function(_DriveModel) _then;

/// Create a copy of DriveModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? path = null,Object? totalSpace = null,Object? usedSpace = null,Object? isRemovable = null,Object? mountPoint = null,Object? type = null,Object? isSelected = null,Object? vendor = freezed,Object? model = freezed,Object? serialNumber = freezed,Object? partitionCount = freezed,Object? isMounted = freezed,}) {
  return _then(_DriveModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,totalSpace: null == totalSpace ? _self.totalSpace : totalSpace // ignore: cast_nullable_to_non_nullable
as int,usedSpace: null == usedSpace ? _self.usedSpace : usedSpace // ignore: cast_nullable_to_non_nullable
as int,isRemovable: null == isRemovable ? _self.isRemovable : isRemovable // ignore: cast_nullable_to_non_nullable
as bool,mountPoint: null == mountPoint ? _self.mountPoint : mountPoint // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DriveType,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,partitionCount: freezed == partitionCount ? _self.partitionCount : partitionCount // ignore: cast_nullable_to_non_nullable
as int?,isMounted: freezed == isMounted ? _self.isMounted : isMounted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
