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
    state = {
      'class': [
        TaskModel(
          id: '123',
          classId: 'test',
          userId: '123',
          name: "レポート",
          deadline: DateTime(2024, 12, 02),
          howToSubmit: "online",
          state: TaskState.inProgress,
        ),
        TaskModel(
          id: 'task1',
          classId: 'test',
          userId: '123',
          name: "期末レポート",
          deadline: DateTime(2024, 11, 31),
          howToSubmit: "classroom",
          state: TaskState.pending,
        ),
      ],
      'class1': [
        TaskModel(
          id: 'task1',
          classId: 'test',
          userId: '123',
          name: "期末レポート",
          deadline: DateTime(2024, 11, 31),
          howToSubmit: "classroom",
          state: TaskState.pending,
        ),
      ],
    };
  }

  String mockNextWeekAt2359 =
      DateFormat(dateFormat).format(DateTime.now().add(Duration(days: 7)));

  @override
  void addTasks({required Map taskData}) {
    isCalled = true;
    lastTaskData = taskData;
    super.addTasks(taskData: taskData);
  }

  @override
  DateTime nextWeekAt2359({required Week dayOfWeek}) {
    return DateTime.now().add(Duration(days: 7));
  }

  @override
  DateTime nextWeekClassStartTime(
      {required Week dayOfWeek, required Period period}) {
    return DateTime.now().add(Duration(days: 7, hours: 9));
  }

  @override
  List<TaskModel> tasksByClassId({required String classId}) {
    return state[classId] ?? [];
  }

  @override
  void deleteTask({required String id, required String classId}) {
    isCalled = true;
    lastDeletedTask = {'id': id, 'classId': classId};
  }
}
