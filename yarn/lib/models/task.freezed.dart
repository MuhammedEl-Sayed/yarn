// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

 String get id; String get title; String? get roomId; String get repeat; List<String> get repeatsOn; String? get assignedTo; int get effort; bool get isDone; String? get createdBy;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&const DeepCollectionEquality().equals(other.repeatsOn, repeatsOn)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.effort, effort) || other.effort == effort)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,roomId,repeat,const DeepCollectionEquality().hash(repeatsOn),assignedTo,effort,isDone,createdBy);

@override
String toString() {
  return 'Task(id: $id, title: $title, roomId: $roomId, repeat: $repeat, repeatsOn: $repeatsOn, assignedTo: $assignedTo, effort: $effort, isDone: $isDone, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? roomId, String repeat, List<String> repeatsOn, String? assignedTo, int effort, bool isDone, String? createdBy
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? roomId = freezed,Object? repeat = null,Object? repeatsOn = null,Object? assignedTo = freezed,Object? effort = null,Object? isDone = null,Object? createdBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as String,repeatsOn: null == repeatsOn ? _self.repeatsOn : repeatsOn // ignore: cast_nullable_to_non_nullable
as List<String>,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,effort: null == effort ? _self.effort : effort // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? roomId,  String repeat,  List<String> repeatsOn,  String? assignedTo,  int effort,  bool isDone,  String? createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.roomId,_that.repeat,_that.repeatsOn,_that.assignedTo,_that.effort,_that.isDone,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? roomId,  String repeat,  List<String> repeatsOn,  String? assignedTo,  int effort,  bool isDone,  String? createdBy)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.roomId,_that.repeat,_that.repeatsOn,_that.assignedTo,_that.effort,_that.isDone,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? roomId,  String repeat,  List<String> repeatsOn,  String? assignedTo,  int effort,  bool isDone,  String? createdBy)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.roomId,_that.repeat,_that.repeatsOn,_that.assignedTo,_that.effort,_that.isDone,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Task implements Task {
  const _Task({required this.id, required this.title, this.roomId, this.repeat = 'once', final  List<String> repeatsOn = const <String>[], this.assignedTo, this.effort = 3, this.isDone = false, this.createdBy}): _repeatsOn = repeatsOn;
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? roomId;
@override@JsonKey() final  String repeat;
 final  List<String> _repeatsOn;
@override@JsonKey() List<String> get repeatsOn {
  if (_repeatsOn is EqualUnmodifiableListView) return _repeatsOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repeatsOn);
}

@override final  String? assignedTo;
@override@JsonKey() final  int effort;
@override@JsonKey() final  bool isDone;
@override final  String? createdBy;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&const DeepCollectionEquality().equals(other._repeatsOn, _repeatsOn)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.effort, effort) || other.effort == effort)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,roomId,repeat,const DeepCollectionEquality().hash(_repeatsOn),assignedTo,effort,isDone,createdBy);

@override
String toString() {
  return 'Task(id: $id, title: $title, roomId: $roomId, repeat: $repeat, repeatsOn: $repeatsOn, assignedTo: $assignedTo, effort: $effort, isDone: $isDone, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? roomId, String repeat, List<String> repeatsOn, String? assignedTo, int effort, bool isDone, String? createdBy
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? roomId = freezed,Object? repeat = null,Object? repeatsOn = null,Object? assignedTo = freezed,Object? effort = null,Object? isDone = null,Object? createdBy = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as String,repeatsOn: null == repeatsOn ? _self._repeatsOn : repeatsOn // ignore: cast_nullable_to_non_nullable
as List<String>,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,effort: null == effort ? _self.effort : effort // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
