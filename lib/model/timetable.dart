import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';

typedef Timetable = Map<Week, Map<Period, ClassModel?>>;

class TimetableModel {
  Timetable generateTimetable(List<ClassModel> classes) {
    // すべての曜日とコマの組み合わせを生成
    final timetable = Map<Week, Map<Period, ClassModel?>>.fromEntries(
      WeekExtension.getWeekdays().map((week) => MapEntry(
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
    final newTimetable = Map<Week, Map<Period, ClassModel?>>.from(
      timetable.map(
        (week, periods) => MapEntry(
          week,
          Map<Period, ClassModel?>.from(periods),
        ),
      ),
    );

    // 新しい授業を追加
    for (final period in cls.period) {
      newTimetable[cls.dayOfWeek]![period] = cls;
    }

    return newTimetable;
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
