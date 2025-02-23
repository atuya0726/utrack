// Mocks generated by Mockito 5.4.4 from annotations
// in utrack/test/mock/usecase.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:utrack/model/constants.dart' as _i5;
import 'package:utrack/model/class.dart' as _i4;
import 'package:utrack/model/task.dart' as _i9;
import 'package:utrack/usecase/class_usecase.dart' as _i2;
import 'package:utrack/usecase/task_usecase.dart' as _i8;
import 'package:utrack/usecase/timetable_usecase.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDateTime_0 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ClassUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockClassUsecase extends _i1.Mock implements _i2.ClassUsecase {
  MockClassUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.ClassModel>> getAllClasses() => (super.noSuchMethod(
        Invocation.method(
          #getAllClasses,
          [],
        ),
        returnValue: _i3.Future<List<_i4.ClassModel>>.value(<_i4.ClassModel>[]),
      ) as _i3.Future<List<_i4.ClassModel>>);

  @override
  _i3.Future<List<_i4.ClassModel>> searchClasses({
    required List<_i4.ClassModel>? classes,
    required String? text,
    required _i5.Week? dayOfWeek,
    required _i5.Period? period,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchClasses,
          [],
          {
            #classes: classes,
            #text: text,
            #dayOfWeek: dayOfWeek,
            #period: period,
          },
        ),
        returnValue: _i3.Future<List<_i4.ClassModel>>.value(<_i4.ClassModel>[]),
      ) as _i3.Future<List<_i4.ClassModel>>);

  @override
  _i3.Future<List<_i4.ClassModel>> filterClasses({
    required List<_i4.ClassModel>? classes,
    required _i5.Grade? grade,
    required _i5.Period? period,
    required _i5.Week? dayOfWeek,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #filterClasses,
          [],
          {
            #classes: classes,
            #grade: grade,
            #period: period,
            #dayOfWeek: dayOfWeek,
          },
        ),
        returnValue: _i3.Future<List<_i4.ClassModel>>.value(<_i4.ClassModel>[]),
      ) as _i3.Future<List<_i4.ClassModel>>);

  @override
  _i3.Future<String> getClassNameById({
    required List<_i4.ClassModel>? classes,
    required String? classId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getClassNameById,
          [],
          {
            #classes: classes,
            #classId: classId,
          },
        ),
        returnValue: _i3.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #getClassNameById,
            [],
            {
              #classes: classes,
              #classId: classId,
            },
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>
      getTimetableByUserId(String? userId) => (super.noSuchMethod(
            Invocation.method(
              #getTimetableByUserId,
              [userId],
            ),
            returnValue: _i3
                .Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>.value(
                <_i5.Week, Map<_i5.Period, _i4.ClassModel?>>{}),
          ) as _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>);

  @override
  _i3.Future<void> addClassToTimetable({
    required String? userId,
    required _i4.ClassModel? cls,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addClassToTimetable,
          [],
          {
            #userId: userId,
            #cls: cls,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteClassFromTimetable({
    required String? userId,
    required _i4.ClassModel? cls,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteClassFromTimetable,
          [],
          {
            #userId: userId,
            #cls: cls,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [TimetableUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockTimetableUsecase extends _i1.Mock implements _i7.TimetableUsecase {
  MockTimetableUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>> getTimetable(
          {required String? userId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTimetable,
          [],
          {#userId: userId},
        ),
        returnValue:
            _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>.value(
                <_i5.Week, Map<_i5.Period, _i4.ClassModel?>>{}),
      ) as _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>);

  @override
  _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>> deleteTimetable({
    required String? userId,
    required _i4.ClassModel? cls,
    required Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>? currentTimetable,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteTimetable,
          [],
          {
            #userId: userId,
            #cls: cls,
            #currentTimetable: currentTimetable,
          },
        ),
        returnValue:
            _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>.value(
                <_i5.Week, Map<_i5.Period, _i4.ClassModel?>>{}),
      ) as _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>);

  @override
  _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>> addTimetable({
    required String? userId,
    required _i4.ClassModel? cls,
    required Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>? currentTimetable,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addTimetable,
          [],
          {
            #userId: userId,
            #cls: cls,
            #currentTimetable: currentTimetable,
          },
        ),
        returnValue:
            _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>.value(
                <_i5.Week, Map<_i5.Period, _i4.ClassModel?>>{}),
      ) as _i3.Future<Map<_i5.Week, Map<_i5.Period, _i4.ClassModel?>>>);
}

/// A class which mocks [TaskUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskUsecase extends _i1.Mock implements _i8.TaskUsecase {
  MockTaskUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i9.TaskModel>> getAllTasks({required String? userId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllTasks,
          [],
          {#userId: userId},
        ),
        returnValue: _i3.Future<List<_i9.TaskModel>>.value(<_i9.TaskModel>[]),
      ) as _i3.Future<List<_i9.TaskModel>>);

  @override
  _i3.Future<List<_i9.TaskModel>> addTask({
    required String? userId,
    required String? classId,
    required String? name,
    required DateTime? deadline,
    required _i5.HowToSubmit? howToSubmit,
    required List<_i9.TaskModel>? currentTasks,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addTask,
          [],
          {
            #userId: userId,
            #classId: classId,
            #name: name,
            #deadline: deadline,
            #howToSubmit: howToSubmit,
            #currentTasks: currentTasks,
          },
        ),
        returnValue: _i3.Future<List<_i9.TaskModel>>.value(<_i9.TaskModel>[]),
      ) as _i3.Future<List<_i9.TaskModel>>);

  @override
  _i3.Future<List<_i9.TaskModel>> deleteTask({
    required String? taskId,
    required List<_i9.TaskModel>? currentTasks,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteTask,
          [],
          {
            #taskId: taskId,
            #currentTasks: currentTasks,
          },
        ),
        returnValue: _i3.Future<List<_i9.TaskModel>>.value(<_i9.TaskModel>[]),
      ) as _i3.Future<List<_i9.TaskModel>>);

  @override
  _i3.Future<List<_i9.TaskModel>> updateTaskStatus({
    required String? taskId,
    required _i5.TaskStatus? status,
    required List<_i9.TaskModel>? currentTasks,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTaskStatus,
          [],
          {
            #taskId: taskId,
            #status: status,
            #currentTasks: currentTasks,
          },
        ),
        returnValue: _i3.Future<List<_i9.TaskModel>>.value(<_i9.TaskModel>[]),
      ) as _i3.Future<List<_i9.TaskModel>>);

  @override
  List<_i9.TaskModel> filterTasks({
    required List<_i9.TaskModel>? tasks,
    String? classId,
    _i5.TaskStatus? status,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #filterTasks,
          [],
          {
            #tasks: tasks,
            #classId: classId,
            #status: status,
          },
        ),
        returnValue: <_i9.TaskModel>[],
      ) as List<_i9.TaskModel>);

  @override
  DateTime calculateNextWeekAt2359({required _i5.Week? dayOfWeek}) =>
      (super.noSuchMethod(
        Invocation.method(
          #calculateNextWeekAt2359,
          [],
          {#dayOfWeek: dayOfWeek},
        ),
        returnValue: _FakeDateTime_0(
          this,
          Invocation.method(
            #calculateNextWeekAt2359,
            [],
            {#dayOfWeek: dayOfWeek},
          ),
        ),
      ) as DateTime);

  @override
  DateTime calculateNextWeekClassStartTime({
    required _i5.Week? dayOfWeek,
    required _i5.Period? period,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #calculateNextWeekClassStartTime,
          [],
          {
            #dayOfWeek: dayOfWeek,
            #period: period,
          },
        ),
        returnValue: _FakeDateTime_0(
          this,
          Invocation.method(
            #calculateNextWeekClassStartTime,
            [],
            {
              #dayOfWeek: dayOfWeek,
              #period: period,
            },
          ),
        ),
      ) as DateTime);

  @override
  String calculateRemainingTime({required DateTime? deadline}) =>
      (super.noSuchMethod(
        Invocation.method(
          #calculateRemainingTime,
          [],
          {#deadline: deadline},
        ),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.method(
            #calculateRemainingTime,
            [],
            {#deadline: deadline},
          ),
        ),
      ) as String);
}
