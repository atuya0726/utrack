// モックTaskNotifierの実装
import 'package:intl/intl.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/viewmodel/task.dart';

class MockTaskNotifier extends TaskNotifier {
  bool isCalled = false;
  Map<dynamic, dynamic>? lastTaskData;
  Map<String, dynamic>? lastDeletedTask;

  MockTaskNotifier() : super() {
    // 初期状態を設定
    state = [
      TaskModel(
        id: '123',
        classId: 'test',
        userId: '123',
        name: "レポート",
        deadline: DateTime(2024, 12, 02),
        howToSubmit: HowToSubmit.online,
        status: TaskStatus.inProgress,
      ),
      TaskModel(
        id: 'task1',
        classId: 'test',
        userId: '123',
        name: "期末レポート",
        deadline: DateTime(2024, 11, 31),
        howToSubmit: HowToSubmit.online,
        status: TaskStatus.inProgress,
      ),
    ];
  }

  String mockNextWeekAt2359 = DateFormat(dateFormat)
      .format(DateTime.now().add(const Duration(days: 7)));

  @override
  Future<void> addTasks({
    required String classId,
    required String name,
    required DateTime deadline,
    required HowToSubmit howToSubmit,
  }) async {
    isCalled = true;
    lastTaskData = {
      'classId': classId,
      'name': name,
      'deadline': deadline,
      'howToSubmit': howToSubmit,
    };
    await super.addTasks(
      classId: classId,
      name: name,
      deadline: deadline,
      howToSubmit: howToSubmit,
    );
  }

  @override
  DateTime nextWeekAt2359({required Week dayOfWeek}) {
    return DateTime.now().add(const Duration(days: 7));
  }

  @override
  DateTime nextWeekClassStartTime(
      {required Week dayOfWeek, required Period period}) {
    return DateTime.now().add(const Duration(days: 7, hours: 9));
  }

  @override
  Future<void> deleteTask(
      {required String taskId, required String classId}) async {
    isCalled = true;
    lastDeletedTask = {'id': taskId, 'classId': classId};
  }
}
