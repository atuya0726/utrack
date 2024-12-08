import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';

typedef Timetable = Map<Week, Map<Period, ClassModel?>>;

class TimetableModel {
  Timetable generateTimetable(List<ClassModel> classes) {
    // すべての曜日とコマの組み合わせを生成
    final timetable = Map<Week, Map<Period, ClassModel?>>.fromEntries(
      Week.values.map((week) => MapEntry(
            week,
            Map<Period, ClassModel?>.fromEntries(
              Period.values.map((period) => MapEntry(period, null)),
            ),
          )),
    );

    // 各クラスを配置
    for (final classModel in classes) {
      for (final period in classModel.period) {
        timetable[classModel.dayOfWeek]![period] = classModel;
      }
    }

    return timetable;
  }

  Timetable add({required ClassModel cls, required Timetable timetable}) {
    final updatedClasses = <ClassModel>[];

    for (final week in Week.values) {
      for (final period in Period.values) {
        final classModel = timetable[week]?[period];
        if (classModel != null) {
          updatedClasses.add(classModel);
        }
      }
    }
    updatedClasses.add(cls);

    return generateTimetable(updatedClasses);
  }

  Timetable delete(
      {required String classId,
      required Timetable timetable,
      required Week dayOfWeek,
      required List<Period> periods}) {
    return {
      ...timetable,
      dayOfWeek: {
        ...timetable[dayOfWeek]!,
        for (final period in periods) period: null,
      },
    };
  }
}
