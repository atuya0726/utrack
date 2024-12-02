import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/mock_variables.dart';

final classProvider = StateNotifierProvider<ClassNotifier, List<ClassModel>>(
  (ref) => ClassNotifier(),
);

class ClassNotifier extends StateNotifier<List<ClassModel>> {
  ClassNotifier() : super([]) {
    fetchClasses();
  }

  List<ClassModel> originClasses = mockClasses;

  void fetchClasses() async {
    try {
      state = mockClasses;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void searchClasses(
      {required String text, required Week dayOfWeek, required Period period}) {
    filterClasses(grade: null, period: period, dayOfWeek: dayOfWeek);
    state = state
        .where((item) => item.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void filterClasses({
    required Grade? grade,
    required Period period,
    required Week dayOfWeek,
  }) {
    List<ClassModel> filterClasses = originClasses;
    if (null != grade) {
      int year = grade.number;
      filterClasses =
          filterClasses.where((element) => element.year == year).toList();
    }
    filterClasses = filterClasses
        .where((element) =>
            element.period == period && element.dayOfWeek == dayOfWeek)
        .toList();
    state = filterClasses;
  }

  String getNameById({required String classId}) {
    final cls = originClasses.firstWhere((cls) => cls.id == classId);
    return cls.name;
  }
}
