// Mocks generated by Mockito 5.4.4 from annotations
// in utrack/test/mock/model.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:utrack/model/constants.dart' as _i3;
import 'package:utrack/model/class.dart' as _i4;
import 'package:utrack/model/timetable.dart' as _i2;

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

/// A class which mocks [TimetableModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockTimetableModel extends _i1.Mock implements _i2.TimetableModel {
  MockTimetableModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>> generateTimetable(
          List<_i4.ClassModel>? classes) =>
      (super.noSuchMethod(
        Invocation.method(
          #generateTimetable,
          [classes],
        ),
        returnValue: <_i3.Week, Map<_i3.Period, _i4.ClassModel?>>{},
      ) as Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>>);

  @override
  Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>> add({
    required _i4.ClassModel? cls,
    required Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>>? timetable,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [],
          {
            #cls: cls,
            #timetable: timetable,
          },
        ),
        returnValue: <_i3.Week, Map<_i3.Period, _i4.ClassModel?>>{},
      ) as Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>>);

  @override
  Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>> delete({
    required String? classId,
    required Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>>? timetable,
    required _i3.Week? dayOfWeek,
    required List<_i3.Period>? periods,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {
            #classId: classId,
            #timetable: timetable,
            #dayOfWeek: dayOfWeek,
            #periods: periods,
          },
        ),
        returnValue: <_i3.Week, Map<_i3.Period, _i4.ClassModel?>>{},
      ) as Map<_i3.Week, Map<_i3.Period, _i4.ClassModel?>>);
}
