import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/repository/class.dart';
import 'package:utrack/repository/user.dart';

final classProvider = StateNotifierProvider<ClassNotifier, List<ClassModel>>(
  (ref) => ClassNotifier(),
);

class ClassNotifier extends StateNotifier<List<ClassModel>> {
  ClassNotifier() : super([]) {
    fetchClasses();
  }

  final ClassRepository classRepository = ClassRepository();
  final UserRepository userRepository = UserRepository();
  final Completer<void> _completer = Completer<void>();
  List<ClassModel> originClasses = [];

  void fetchClasses() async {
    try {
      originClasses = await classRepository.fetchClasses();
      state = originClasses;
      _completer.complete();
    } catch (e) {
      debugPrint(e.toString());
      _completer.completeError(e);
    }
  }

  Future<void> searchClasses(
      {required String text,
      required Week dayOfWeek,
      required Period period}) async {
    await filterClasses(grade: null, period: period, dayOfWeek: dayOfWeek);
    state = state
        .where((item) => item.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  Future<void> filterClasses({
    required Grade? grade,
    required Period period,
    required Week dayOfWeek,
  }) async {
    await _completer.future;

    state = originClasses.where((element) {
      final matchesGrade = grade == null || element.year.contains(grade.number);
      final matchesPeriod = element.period.contains(period);
      final matchesDay = element.dayOfWeek == dayOfWeek;

      return matchesGrade && matchesPeriod && matchesDay;
    }).toList();
  }

  Future<String> getNameById({required String classId}) async {
    await _completer.future;
    if (originClasses.isEmpty) {
      return '';
    }
    final cls = originClasses.firstWhere(
      (cls) => cls.id == classId,
      orElse: () => ClassModel.empty(),
    );
    return cls.name;
  }
}
