import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/mock_variables.dart';

final timetableProvider = StateNotifierProvider<TimetableNotifier,
    Map<Week, Map<Period, ClassModel?>>>(
  (ref) => TimetableNotifier(),
);

class TimetableNotifier
    extends StateNotifier<Map<Week, Map<Period, ClassModel?>>> {
  TimetableNotifier() : super({}) {
    fetchTimetable();
  }

  void fetchTimetable() async {
    try {
      state = mockTimetable;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addTimetable({required ClassModel cls}) {
    state = {
      ...state,
      cls.dayOfWeek: {
        ...state[cls.dayOfWeek] ?? {},
        cls.period: cls,
      },
    };
  }
}
