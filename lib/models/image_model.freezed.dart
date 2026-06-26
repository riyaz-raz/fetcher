// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageModel {

 String get id; String get name; String get path; int get size; ImageType get type; String get fileExtension; DateTime get dateAdded; String? get md5Checksum; String? get sha256Checksum; bool? get isValid; bool? get isCompressed; String? get compressionType;
/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageModelCopyWith<ImageModel> get copyWith => _$ImageModelCopyWithImpl<ImageModel>(this as ImageModel, _$identity);

  /// Serializes this ImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileExtension, fileExtension) || other.fileExtension == fileExtension)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.md5Checksum, md5Checksum) || other.md5Checksum == md5Checksum)&&(identical(other.sha256Checksum, sha256Checksum) || other.sha256Checksum == sha256Checksum)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.isCompressed, isCompressed) || other.isCompressed == isCompressed)&&(identical(other.compressionType, compressionType) || other.compressionType == compressionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,size,type,fileExtension,dateAdded,md5Checksum,sha256Checksum,isValid,isCompressed,compressionType);

@override
String toString() {
  return 'ImageModel(id: $id, name: $name, path: $path, size: $size, type: $type, fileExtension: $fileExtension, dateAdded: $dateAdded, md5Checksum: $md5Checksum, sha256Checksum: $sha256Checksum, isValid: $isValid, isCompressed: $isCompressed, compressionType: $compressionType)';
}


}

/// @nodoc
abstract mixin class $ImageModelCopyWith<$Res>  {
  factory $ImageModelCopyWith(ImageModel value, $Res Function(ImageModel) _then) = _$ImageModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String path, int size, ImageType type, String fileExtension, DateTime dateAdded, String? md5Checksum, String? sha256Checksum, bool? isValid, bool? isCompressed, String? compressionType
});




}
/// @nodoc
class _$ImageModelCopyWithImpl<$Res>
    implements $ImageModelCopyWith<$Res> {
  _$ImageModelCopyWithImpl(this._self, this._then);

  final ImageModel _self;
  final $Res Function(ImageModel) _then;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? path = null,Object? size = null,Object? type = null,Object? fileExtension = null,Object? dateAdded = null,Object? md5Checksum = freezed,Object? sha256Checksum = freezed,Object? isValid = freezed,Object? isCompressed = freezed,Object? compressionType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ImageType,fileExtension: null == fileExtension ? _self.fileExtension : fileExtension // ignore: cast_nullable_to_non_nullable
as String,dateAdded: null == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime,md5Checksum: freezed == md5Checksum ? _self.md5Checksum : md5Checksum // ignore: cast_nullable_to_non_nullable
as String?,sha256Checksum: freezed == sha256Checksum ? _self.sha256Checksum : sha256Checksum // ignore: cast_nullable_to_non_nullable
as String?,isValid: freezed == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool?,isCompressed: freezed == isCompressed ? _self.isCompressed : isCompressed // ignore: cast_nullable_to_non_nullable
as bool?,compressionType: freezed == compressionType ? _self.compressionType : compressionType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageModel].
extension ImageModelPatterns on ImageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageModel value)  $default,){
final _that = this;
switch (_that) {
case _ImageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String path,  int size,  ImageType type,  String fileExtension,  DateTime dateAdded,  String? md5Checksum,  String? sha256Checksum,  bool? isValid,  bool? isCompressed,  String? compressionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.size,_that.type,_that.fileExtension,_that.dateAdded,_that.md5Checksum,_that.sha256Checksum,_that.isValid,_that.isCompressed,_that.compressionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String path,  int size,  ImageType type,  String fileExtension,  DateTime dateAdded,  String? md5Checksum,  String? sha256Checksum,  bool? isValid,  bool? isCompressed,  String? compressionType)  $default,) {final _that = this;
switch (_that) {
case _ImageModel():
return $default(_that.id,_that.name,_that.path,_that.size,_that.type,_that.fileExtension,_that.dateAdded,_that.md5Checksum,_that.sha256Checksum,_that.isValid,_that.isCompressed,_that.compressionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String path,  int size,  ImageType type,  String fileExtension,  DateTime dateAdded,  String? md5Checksum,  String? sha256Checksum,  bool? isValid,  bool? isCompressed,  String? compressionType)?  $default,) {final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.size,_that.type,_that.fileExtension,_that.dateAdded,_that.md5Checksum,_that.sha256Checksum,_that.isValid,_that.isCompressed,_that.compressionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageModel implements ImageModel {
  const _ImageModel({required this.id, required this.name, required this.path, required this.size, required this.type, required this.fileExtension, required this.dateAdded, this.md5Checksum, this.sha256Checksum, this.isValid, this.isCompressed, this.compressionType});
  factory _ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String path;
@override final  int size;
@override final  ImageType type;
@override final  String fileExtension;
@override final  DateTime dateAdded;
@override final  String? md5Checksum;
@override final  String? sha256Checksum;
@override final  bool? isValid;
@override final  bool? isCompressed;
@override final  String? compressionType;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageModelCopyWith<_ImageModel> get copyWith => __$ImageModelCopyWithImpl<_ImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileExtension, fileExtension) || other.fileExtension == fileExtension)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.md5Checksum, md5Checksum) || other.md5Checksum == md5Checksum)&&(identical(other.sha256Checksum, sha256Checksum) || other.sha256Checksum == sha256Checksum)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.isCompressed, isCompressed) || other.isCompressed == isCompressed)&&(identical(other.compressionType, compressionType) || other.compressionType == compressionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,size,type,fileExtension,dateAdded,md5Checksum,sha256Checksum,isValid,isCompressed,compressionType);

@override
String toString() {
  return 'ImageModel(id: $id, name: $name, path: $path, size: $size, type: $type, fileExtension: $fileExtension, dateAdded: $dateAdded, md5Checksum: $md5Checksum, sha256Checksum: $sha256Checksum, isValid: $isValid, isCompressed: $isCompressed, compressionType: $compressionType)';
}


}

/// @nodoc
abstract mixin class _$ImageModelCopyWith<$Res> implements $ImageModelCopyWith<$Res> {
  factory _$ImageModelCopyWith(_ImageModel value, $Res Function(_ImageModel) _then) = __$ImageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String path, int size, ImageType type, String fileExtension, DateTime dateAdded, String? md5Checksum, String? sha256Checksum, bool? isValid, bool? isCompressed, String? compressionType
});




}
/// @nodoc
class __$ImageModelCopyWithImpl<$Res>
    implements _$ImageModelCopyWith<$Res> {
  __$ImageModelCopyWithImpl(this._self, this._then);

  final _ImageModel _self;
  final $Res Function(_ImageModel) _then;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? path = null,Object? size = null,Object? type = null,Object? fileExtension = null,Object? dateAdded = null,Object? md5Checksum = freezed,Object? sha256Checksum = freezed,Object? isValid = freezed,Object? isCompressed = freezed,Object? compressionType = freezed,}) {
  return _then(_ImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ImageType,fileExtension: null == fileExtension ? _self.fileExtension : fileExtension // ignore: cast_nullable_to_non_nullable
as String,dateAdded: null == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime,md5Checksum: freezed == md5Checksum ? _self.md5Checksum : md5Checksum // ignore: cast_nullable_to_non_nullable
as String?,sha256Checksum: freezed == sha256Checksum ? _self.sha256Checksum : sha256Checksum // ignore: cast_nullable_to_non_nullable
as String?,isValid: freezed == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool?,isCompressed: freezed == isCompressed ? _self.isCompressed : isCompressed // ignore: cast_nullable_to_non_nullable
as bool?,compressionType: freezed == compressionType ? _self.compressionType : compressionType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
