import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/usecase/class_usecase.dart';

final classProvider = StateNotifierProvider<ClassNotifier, List<ClassModel>>(
  (ref) => ClassNotifier(),
);

class ClassNotifier extends StateNotifier<List<ClassModel>> {
  ClassNotifier({
    ClassUsecase? classUsecase,
  }) : super([]) {
    this.classUsecase = classUsecase ?? ClassUsecase();
    fetchClasses();
  }

  late ClassUsecase classUsecase;
  @protected
  final Completer<void> _completer = Completer<void>();
  List<ClassModel> originClasses = [];

  Future<void> waitForInitialization() => _completer.future;

  void fetchClasses() async {
    try {
      originClasses = await classUsecase.getAllClasses();
      state = originClasses;
      _completer.complete();
    } catch (e) {
      state = [];
      originClasses = [];
      debugPrint(e.toString());
      _completer.completeError(e);
    }
  }

  Future<void> searchClasses({
    required String text,
    required Week dayOfWeek,
    required Period period,
  }) async {
    await waitForInitialization();
    state = await classUsecase.searchClasses(
      classes: originClasses,
      text: text,
      dayOfWeek: dayOfWeek,
      period: period,
    );
  }

  Future<void> filterClasses({
    required Grade? grade,
    required Major? major,
    required Semester? semester,
    required Period period,
    required Week dayOfWeek,
  }) async {
    await waitForInitialization();
    state = await classUsecase.filterClasses(
      classes: originClasses,
      grade: grade,
      semester: semester,
      major: major,
      period: period,
      dayOfWeek: dayOfWeek,
    );
  }

  Future<String> getNameById({required String classId}) async {
    await waitForInitialization();
    return await classUsecase.getClassNameById(
      classes: originClasses,
      classId: classId,
    );
  }
}
