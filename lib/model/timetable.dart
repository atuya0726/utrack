import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';

class TimetableModel {
  final Map<String, Map<int, ClassModel?>> timetable;

  TimetableModel(List<ClassModel> classes)
      : timetable = _generateTimetable(classes);

  static Map<String, Map<int, ClassModel?>> _generateTimetable(
      List<ClassModel> classes) {
    // 曜日ごとの初期値 (すべてのコマが null)
    Map<String, Map<int, ClassModel?>> timetable = {
      'mon': {1: null, 2: null, 3: null, 4: null, 5: null},
      'tue': {1: null, 2: null, 3: null, 4: null, 5: null},
      'wed': {1: null, 2: null, 3: null, 4: null, 5: null},
      'thu': {1: null, 2: null, 3: null, 4: null, 5: null},
      'fri': {1: null, 2: null, 3: null, 4: null, 5: null},
    };

    // 各クラスを対応する曜日とコマに配置
    for (var classModel in classes) {
      timetable[classModel.dayOfWeek]?[classModel.period.number] = classModel;
    }

    return timetable;
  }

  // 特定の曜日と時間のクラスを取得するメソッド
  ClassModel? getClass(String day, int period) {
    return timetable[day]?[period];
  }
}
