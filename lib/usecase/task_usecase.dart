import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/repository/task.dart';

class TaskUsecase {
  final TaskRepository _taskRepository;

  TaskUsecase({
    TaskRepository? taskRepository,
  }) : _taskRepository = taskRepository ?? TaskRepository();

  Future<List<TaskModel>> getAllTasks({required String userId}) async {
    final tasks = await _taskRepository.getTasks(userId: userId);
    return tasks;
  }

  Future<Map<String, List<TaskModel>>> addTask({
    required String userId,
    required String classId,
    required String name,
    required DateTime deadline,
    required HowToSubmit howToSubmit,
    String? memo,
    required List<TaskModel> currentTasks,
    required List<TaskModel> originTasks,
  }) async {
    final task = TaskModel.addTask(
      classId: classId,
      name: name,
      userId: userId,
      deadline: deadline,
      howToSubmit: howToSubmit,
      status: TaskStatus.inProgress,
      memo: memo,
    );

    await _taskRepository.addTask(task: task);
    final updatedTasks = [...currentTasks, task];
    final updatedOriginTasks = [...originTasks, task];
    final result = {
      "state": updatedTasks,
      "origin": updatedOriginTasks,
    };
    return result;
  }

  Future<Map<String, List<TaskModel>>> deleteTask({
    required String taskId,
    required List<TaskModel> currentTasks,
    required List<TaskModel> originTasks,
  }) async {
    await _taskRepository.deleteTask(taskId: taskId);
    final updatedTasks =
        currentTasks.where((task) => task.id != taskId).toList();
    final updatedOriginTasks =
        originTasks.where((task) => task.id != taskId).toList();
    final result = {
      "state": updatedTasks,
      "origin": updatedOriginTasks,
    };
    return result;
  }

  Future<Map<String, List<TaskModel>>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    required List<TaskModel> currentTasks,
    required List<TaskModel> originTasks,
  }) async {
    await _taskRepository.updateTaskStatus(
      taskId: taskId,
      status: status,
    );

    final updatedTasks = currentTasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(status: status);
      }
      return task;
    }).toList();

    final updatedOriginTasks = originTasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(status: status);
      }
      return task;
    }).toList();

    final result = {
      "state": updatedTasks,
      "origin": updatedOriginTasks,
    };

    return result;
  }

  List<TaskModel> filterTasks({
    required List<TaskModel> tasks,
    String? classId,
    TaskStatus? status,
  }) {
    final filteredTasks = tasks
        .where((task) =>
            (classId == null || task.classId == classId) &&
            (status == null || task.status == status))
        .toList();

    filteredTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return filteredTasks;
  }

  List<TaskModel> validateTasks({required List<TaskModel> tasks}) {
    for (var task in tasks) {
      if (task.deadline.isBefore(clock.now()) &&
          task.status == TaskStatus.inProgress) {
        task.status = TaskStatus.expired;
      }
    }
    return tasks;
  }

  DateTime calculateNextWeekAt2359({required Week dayOfWeek}) {
    DateTime date = clock.now();
    int weekday = date.weekday;
    int daysToThursday = dayOfWeek.number - weekday;
    date = date.add(Duration(days: daysToThursday));
    DateTime nextWeek = date.add(const Duration(days: 6));
    return DateTime(
      nextWeek.year,
      nextWeek.month,
      nextWeek.day,
      23,
      59,
    );
  }

  DateTime calculateNextWeekClassStartTime({
    required Week dayOfWeek,
    required Period period,
  }) {
    DateTime date = clock.now();
    int weekday = date.weekday;
    int daysToThursday = dayOfWeek.number - weekday;
    date = date.add(Duration(days: daysToThursday));
    DateTime nextWeek = date.add(const Duration(days: 7));

    return DateTime(
      nextWeek.year,
      nextWeek.month,
      nextWeek.day,
      period.startTimeHour,
      period.startTimeMinute,
    );
  }

  String calculateRemainingTime({required DateTime deadline}) {
    final difference = deadline.difference(clock.now());

    if (difference.isNegative) {
      final formatter = DateFormat(dateFormat);
      return '${formatter.format(deadline)} 〆切';
    } else if (difference.inDays == 0 && difference.inHours == 0) {
      return '${difference.inMinutes % 60}分後';
    } else if (difference.inDays == 0) {
      return '${difference.inHours % 24}時間${difference.inMinutes % 60}分後';
    } else {
      return '${difference.inDays}日${difference.inHours % 24}時間${difference.inMinutes % 60}分後';
    }
  }

  Color getColor(DateTime deadline, TaskStatus status) {
    if (status == TaskStatus.completed) {
      return Colors.grey;
    }
    final difference = deadline.difference(clock.now());
    if (difference.isNegative) {
      return Colors.grey;
    } else if (difference.inDays == 0) {
      return Colors.red;
    } else if (difference.inDays == 1) {
      return Colors.orange;
    } else if (difference.inDays == 2) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
