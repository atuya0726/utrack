import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/viewmodel/mock_variables.dart';
import 'package:uuid/uuid.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, Map<String, List<TaskModel>>>(
  (ref) => TaskNotifier(),
);

class TaskNotifier extends StateNotifier<Map<String, List<TaskModel>>> {
  TaskNotifier() : super({}) {
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      Map<String, List<TaskModel>> tasks = {};
      for (var cls in mockClasses) {
        tasks[cls.id] = mockTasks;
      }
      state = tasks;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String calcRemainingDays({required DateTime datetime}) {
    final difference = datetime.difference(DateTime.now());

    if (difference.inDays == 0 && difference.inHours == 0) {
      return '${difference.inMinutes % 60}分後';
    } else if (difference.inDays == 0) {
      return '${difference.inHours % 24}時間${difference.inMinutes % 60}分後';
    } else {
      return '${difference.inDays}日${difference.inHours % 24}時間${difference.inMinutes % 60}分後';
    }
  }

  void addTasks({required Map taskData}) {
    const uuid = Uuid();
    final classId = taskData['classId'] as String;

    // 修正: 新しいタスクリストを作成
    final updatedTasks = {...state};
    final currentTasks = updatedTasks[classId] ?? [];
    updatedTasks[classId] = [
      ...currentTasks,
      TaskModel(
        id: uuid.v4(),
        classId: classId,
        userId: taskData['userId'],
        name: taskData['name'],
        deadline: taskData['deadline'],
        howToSubmit: taskData['howToSubmit'],
        state: TaskState.pending,
      )
    ];

    state = updatedTasks;
  }

  void deleteTask({required String id, required String classId}) {
    state = {
      ...state,
      classId: state[classId]!.where((element) => element.id != id).toList(),
    };
  }

  List<TaskModel> allTasks() {
    var tasks = state.values.expand((list) => list).toList();
    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return tasks;
  }

  List<TaskModel> tasksByClassId({required String classId}) {
    var tasks = state[classId] ?? [];
    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return tasks;
  }

  DateTime nextWeekAt2359({required Week dayOfWeek}) {
    DateTime date = DateTime.now();
    int weekday = date.weekday;
    int daysToThursday = dayOfWeek.number - weekday;
    date = date.add(Duration(days: daysToThursday));
    DateTime nextWeek = date.add(const Duration(days: 7));
    DateTime nextWeekAt2359 = DateTime(
      nextWeek.year,
      nextWeek.month,
      nextWeek.day,
      23,
      59,
    );
    return nextWeekAt2359;
  }

  DateTime nextWeekClassStartTime(
      {required Week dayOfWeek, required Period period}) {
    DateTime date = DateTime.now();
    int weekday = date.weekday;
    int daysToThursday = dayOfWeek.number - weekday;
    date = date.add(Duration(days: daysToThursday));
    DateTime nextWeek = date.add(const Duration(days: 7));

    DateTime nextWeekAt2359 = DateTime(
      nextWeek.year,
      nextWeek.month,
      nextWeek.day,
      period.startTimeHour,
      period.startTimeMinute,
    );
    return nextWeekAt2359;
  }
}
