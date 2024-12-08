import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/repository/task.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
  (ref) => TaskNotifier(),
);

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    fetchTasks();
  }
  TaskRepository taskRepository = TaskRepository();
  final Completer<void> _completer = Completer<void>();
  final String userId = 'SrnN1kD4PPyTiqVRwFhl';
  List<TaskModel> originTasks = [];

  void fetchTasks() async {
    try {
      originTasks = await taskRepository.getTasks(userId: userId);
      state = originTasks;
      _completer.complete();
    } catch (e) {
      debugPrint(e.toString());
      _completer.completeError(e);
      throw Exception('Failed to fetch tasks in ViewModel: $e');
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

  Future<void> addTasks({
    required String classId,
    required String name,
    required DateTime deadline,
    required HowToSubmit howToSubmit,
  }) async {
    final task = TaskModel.addTask(
      classId: classId,
      name: name,
      userId: userId,
      deadline: deadline,
      howToSubmit: howToSubmit,
      status: TaskStatus.inProgress,
    );

    state = [...state, task];
    originTasks.add(task);

    try {
      await taskRepository.addTask(task: task);
    } catch (e) {
      // エラー時は状態を元に戻す
      originTasks.removeLast();
      state = originTasks;
      debugPrint(e.toString());
      throw Exception('タスクの保存に失敗しました: $e');
    }
  }

  Future<void> deleteTask(
      {required String taskId, required String classId}) async {
    final deleteTask =
        originTasks.firstWhere((element) => element.id == taskId);
    originTasks.remove(deleteTask);
    state = originTasks;
    try {
      await taskRepository.deleteTask(taskId: taskId);
    } catch (e) {
      debugPrint(e.toString());
      // エラー時は状態を元に戻す
      originTasks.add(deleteTask);
      state = originTasks;
      throw Exception('タスクの削除に失敗しました: $e');
    }
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    final updateTask =
        originTasks.firstWhere((element) => element.id == taskId);
    final originStatus = updateTask.status;
    originTasks.remove(updateTask);
    updateTask.status = status;
    originTasks.add(updateTask);
    state = originTasks;
    try {
      await taskRepository.updateTaskStatus(taskId: taskId, status: status);
    } catch (e) {
      debugPrint(e.toString());
      // エラー時は状態を元に戻す
      originTasks.remove(updateTask);
      updateTask.status = originStatus;
      originTasks.add(updateTask);
      state = originTasks;
      throw Exception('タスクのステータス更新に失敗しました: $e');
    }
  }

  void deleteTasks({required String classId}) {
    originTasks.removeWhere((element) => element.classId == classId);
    state = originTasks;
  }

  Future<void> filterTasks({String? classId, TaskStatus? status}) async {
    await _completer.future;
    if (originTasks.isEmpty) {
      return;
    }

    for (var task in originTasks) {
      if (task.deadline.isBefore(DateTime.now())) {
        task.status = TaskStatus.expired;
      }
    }
    state = originTasks
        .where((task) =>
            (classId == null || task.classId == classId) &&
            (status == null || task.status == status))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
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
