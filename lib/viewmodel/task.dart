import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/usecase/task_usecase.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
  (ref) => TaskNotifier(),
);

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  late TaskUsecase taskUsecase;
  late FirebaseAuth firebaseAuth;
  late final User? user;
  late final String userId;
  final _completer = Completer<void>();
  List<TaskModel> originTasks = [];

  TaskNotifier({
    TaskUsecase? taskUsecase,
    FirebaseAuth? firebaseAuth,
  }) : super([]) {
    this.taskUsecase = taskUsecase ?? TaskUsecase();
    this.firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    user = this.firebaseAuth.currentUser;
    userId = this.firebaseAuth.currentUser?.uid ?? '';
    fetchTasks();
  }

  @override
  set state(List<TaskModel> value) {
    super.state = taskUsecase.validateTasks(tasks: value);
  }

  Future<void> waitForInitialization() => _completer.future;

  void fetchTasks() async {
    try {
      originTasks = await taskUsecase.getAllTasks(userId: userId);
      state = originTasks;
      _completer.complete();
    } catch (e) {
      debugPrint(e.toString());
      _completer.completeError(e);
    }
  }

  Future<void> addTask({
    required String classId,
    required String name,
    required DateTime deadline,
    required HowToSubmit howToSubmit,
    String? memo,
  }) async {
    await waitForInitialization();
    final result = await taskUsecase.addTask(
      userId: userId,
      classId: classId,
      name: name,
      deadline: deadline,
      howToSubmit: howToSubmit,
      memo: memo,
      currentTasks: state,
      originTasks: originTasks,
    );
    state = result["state"] ?? [];
    originTasks = result["origin"] ?? [];
  }

  Future<void> deleteTask({required String taskId}) async {
    await waitForInitialization();
    final result = await taskUsecase.deleteTask(
      taskId: taskId,
      currentTasks: state,
      originTasks: originTasks,
    );
    state = result["state"] ?? [];
    originTasks = result["origin"] ?? [];
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    await waitForInitialization();
    final result = await taskUsecase.updateTaskStatus(
      taskId: taskId,
      status: status,
      currentTasks: state,
      originTasks: originTasks,
    );
    state = result["state"] ?? [];
    originTasks = result["origin"] ?? [];
  }

  Future<void> filterTasks({String? classId, TaskStatus? status}) async {
    await waitForInitialization();
    state = taskUsecase.filterTasks(
      tasks: originTasks,
      classId: classId,
      status: status,
    );
  }

  String calcRemainingDays({required DateTime datetime}) {
    return taskUsecase.calculateRemainingTime(deadline: datetime);
  }

  Color getColor(DateTime deadline, TaskStatus status) {
    return taskUsecase.getColor(deadline, status);
  }

  DateTime nextWeekAt2359({required Week dayOfWeek}) {
    return taskUsecase.calculateNextWeekAt2359(dayOfWeek: dayOfWeek);
  }

  DateTime nextWeekClassStartTime({
    required Week dayOfWeek,
    required Period period,
  }) {
    return taskUsecase.calculateNextWeekClassStartTime(
      dayOfWeek: dayOfWeek,
      period: period,
    );
  }

  bool noTask() {
    return originTasks.isEmpty;
  }
}
