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

 String get id; String get createdBy; String get name; bool get isActive; String? get description; String get repUnit; int? get every; List<String> get repeatsOn; int get monthlyOn; DateTime? get lastCompleted; DateTime get lastUpdated; List<String> get assignedTo; String? get roomId;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&(identical(other.repUnit, repUnit) || other.repUnit == repUnit)&&(identical(other.every, every) || other.every == every)&&const DeepCollectionEquality().equals(other.repeatsOn, repeatsOn)&&(identical(other.monthlyOn, monthlyOn) || other.monthlyOn == monthlyOn)&&(identical(other.lastCompleted, lastCompleted) || other.lastCompleted == lastCompleted)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other.assignedTo, assignedTo)&&(identical(other.roomId, roomId) || other.roomId == roomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,name,isActive,description,repUnit,every,const DeepCollectionEquality().hash(repeatsOn),monthlyOn,lastCompleted,lastUpdated,const DeepCollectionEquality().hash(assignedTo),roomId);

@override
String toString() {
  return 'Task(id: $id, createdBy: $createdBy, name: $name, isActive: $isActive, description: $description, repUnit: $repUnit, every: $every, repeatsOn: $repeatsOn, monthlyOn: $monthlyOn, lastCompleted: $lastCompleted, lastUpdated: $lastUpdated, assignedTo: $assignedTo, roomId: $roomId)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String createdBy, String name, bool isActive, String? description, String repUnit, int? every, List<String> repeatsOn, int monthlyOn, DateTime? lastCompleted, DateTime lastUpdated, List<String> assignedTo, String? roomId
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdBy = null,Object? name = null,Object? isActive = null,Object? description = freezed,Object? repUnit = null,Object? every = freezed,Object? repeatsOn = null,Object? monthlyOn = null,Object? lastCompleted = freezed,Object? lastUpdated = null,Object? assignedTo = null,Object? roomId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,repUnit: null == repUnit ? _self.repUnit : repUnit // ignore: cast_nullable_to_non_nullable
as String,every: freezed == every ? _self.every : every // ignore: cast_nullable_to_non_nullable
as int?,repeatsOn: null == repeatsOn ? _self.repeatsOn : repeatsOn // ignore: cast_nullable_to_non_nullable
as List<String>,monthlyOn: null == monthlyOn ? _self.monthlyOn : monthlyOn // ignore: cast_nullable_to_non_nullable
as int,lastCompleted: freezed == lastCompleted ? _self.lastCompleted : lastCompleted // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as List<String>,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String createdBy,  String name,  bool isActive,  String? description,  String repUnit,  int? every,  List<String> repeatsOn,  int monthlyOn,  DateTime? lastCompleted,  DateTime lastUpdated,  List<String> assignedTo,  String? roomId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.createdBy,_that.name,_that.isActive,_that.description,_that.repUnit,_that.every,_that.repeatsOn,_that.monthlyOn,_that.lastCompleted,_that.lastUpdated,_that.assignedTo,_that.roomId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String createdBy,  String name,  bool isActive,  String? description,  String repUnit,  int? every,  List<String> repeatsOn,  int monthlyOn,  DateTime? lastCompleted,  DateTime lastUpdated,  List<String> assignedTo,  String? roomId)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.createdBy,_that.name,_that.isActive,_that.description,_that.repUnit,_that.every,_that.repeatsOn,_that.monthlyOn,_that.lastCompleted,_that.lastUpdated,_that.assignedTo,_that.roomId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String createdBy,  String name,  bool isActive,  String? description,  String repUnit,  int? every,  List<String> repeatsOn,  int monthlyOn,  DateTime? lastCompleted,  DateTime lastUpdated,  List<String> assignedTo,  String? roomId)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.createdBy,_that.name,_that.isActive,_that.description,_that.repUnit,_that.every,_that.repeatsOn,_that.monthlyOn,_that.lastCompleted,_that.lastUpdated,_that.assignedTo,_that.roomId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Task implements Task {
  const _Task({required this.id, required this.createdBy, required this.name, this.isActive = true, this.description, required this.repUnit, this.every, final  List<String> repeatsOn = const <String>[], this.monthlyOn = 1, this.lastCompleted, required this.lastUpdated, final  List<String> assignedTo = const <String>[], this.roomId}): _repeatsOn = repeatsOn,_assignedTo = assignedTo;
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override final  String id;
@override final  String createdBy;
@override final  String name;
@override@JsonKey() final  bool isActive;
@override final  String? description;
@override final  String repUnit;
@override final  int? every;
 final  List<String> _repeatsOn;
@override@JsonKey() List<String> get repeatsOn {
  if (_repeatsOn is EqualUnmodifiableListView) return _repeatsOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repeatsOn);
}

@override@JsonKey() final  int monthlyOn;
@override final  DateTime? lastCompleted;
@override final  DateTime lastUpdated;
 final  List<String> _assignedTo;
@override@JsonKey() List<String> get assignedTo {
  if (_assignedTo is EqualUnmodifiableListView) return _assignedTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignedTo);
}

@override final  String? roomId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&(identical(other.repUnit, repUnit) || other.repUnit == repUnit)&&(identical(other.every, every) || other.every == every)&&const DeepCollectionEquality().equals(other._repeatsOn, _repeatsOn)&&(identical(other.monthlyOn, monthlyOn) || other.monthlyOn == monthlyOn)&&(identical(other.lastCompleted, lastCompleted) || other.lastCompleted == lastCompleted)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other._assignedTo, _assignedTo)&&(identical(other.roomId, roomId) || other.roomId == roomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,name,isActive,description,repUnit,every,const DeepCollectionEquality().hash(_repeatsOn),monthlyOn,lastCompleted,lastUpdated,const DeepCollectionEquality().hash(_assignedTo),roomId);

@override
String toString() {
  return 'Task(id: $id, createdBy: $createdBy, name: $name, isActive: $isActive, description: $description, repUnit: $repUnit, every: $every, repeatsOn: $repeatsOn, monthlyOn: $monthlyOn, lastCompleted: $lastCompleted, lastUpdated: $lastUpdated, assignedTo: $assignedTo, roomId: $roomId)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String createdBy, String name, bool isActive, String? description, String repUnit, int? every, List<String> repeatsOn, int monthlyOn, DateTime? lastCompleted, DateTime lastUpdated, List<String> assignedTo, String? roomId
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdBy = null,Object? name = null,Object? isActive = null,Object? description = freezed,Object? repUnit = null,Object? every = freezed,Object? repeatsOn = null,Object? monthlyOn = null,Object? lastCompleted = freezed,Object? lastUpdated = null,Object? assignedTo = null,Object? roomId = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,repUnit: null == repUnit ? _self.repUnit : repUnit // ignore: cast_nullable_to_non_nullable
as String,every: freezed == every ? _self.every : every // ignore: cast_nullable_to_non_nullable
as int?,repeatsOn: null == repeatsOn ? _self._repeatsOn : repeatsOn // ignore: cast_nullable_to_non_nullable
as List<String>,monthlyOn: null == monthlyOn ? _self.monthlyOn : monthlyOn // ignore: cast_nullable_to_non_nullable
as int,lastCompleted: freezed == lastCompleted ? _self.lastCompleted : lastCompleted // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,assignedTo: null == assignedTo ? _self._assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as List<String>,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
