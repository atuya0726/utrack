import 'package:clock/clock.dart';
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
    return _updateExpiredTasks(tasks);
  }

  Future<Map<String, List<TaskModel>>> addTask({
    required String userId,
    required String classId,
    required String name,
    required DateTime deadline,
    required HowToSubmit howToSubmit,
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
    );

    await _taskRepository.addTask(task: task);
    final updatedTasks = [...currentTasks, task];
    final updatedOriginTasks = [...originTasks, task];
    final result = {
      "state": _updateExpiredTasks(updatedTasks),
      "origin": _updateExpiredTasks(updatedOriginTasks),
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
      "state": _updateExpiredTasks(updatedTasks),
      "origin": _updateExpiredTasks(updatedOriginTasks),
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
      "state": _updateExpiredTasks(updatedTasks),
      "origin": _updateExpiredTasks(updatedOriginTasks),
    };

    return result;
  }

  List<TaskModel> _updateExpiredTasks(List<TaskModel> tasks) {
    for (var task in tasks) {
      if (task.deadline.isBefore(clock.now()) &&
          task.status == TaskStatus.inProgress) {
        task.status = TaskStatus.expired;
      }
    }
    return tasks;
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
    return _updateExpiredTasks(filteredTasks);
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

    if (difference.inDays == 0 && difference.inHours == 0) {
      return '${difference.inMinutes % 60}分後';
    } else if (difference.inDays == 0) {
      return '${difference.inHours % 24}時間${difference.inMinutes % 60}分後';
    } else {
      return '${difference.inDays}日${difference.inHours % 24}時間${difference.inMinutes % 60}分後';
    }
  }
}
