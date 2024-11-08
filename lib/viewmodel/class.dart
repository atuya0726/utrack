import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/mock_variables.dart';

final classProvider = StateNotifierProvider<ClassNotifier, List<ClassModel>>(
  (ref) => ClassNotifier(),
);

class ClassNotifier extends StateNotifier<List<ClassModel>> {
  List<ClassModel> originClasses = [];

  ClassNotifier() : super([]);

  void fetchClasses() async {
    try {
      originClasses = classes;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
