import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/model/timetable.dart';
import 'package:utrack/usecase/timetable_usecase.dart';

final timetableProvider = StateNotifierProvider<TimetableNotifier, Timetable>(
  (ref) => TimetableNotifier(),
);

class TimetableNotifier extends StateNotifier<Timetable> {
  late TimetableUsecase timetableUsecase;
  late FirebaseAuth firebaseAuth;
  late final User? user;
  late final String userId;
  final _completer = Completer<void>();

  TimetableNotifier({
    TimetableUsecase? timetableUsecase,
    FirebaseAuth? firebaseAuth,
  }) : super(Timetable()) {
    this.timetableUsecase = timetableUsecase ?? TimetableUsecase();
    this.firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    user = this.firebaseAuth.currentUser;
    userId = this.firebaseAuth.currentUser?.uid ?? '';
    fetchTimetable();
  }

  Future<void> waitForInitialization() => _completer.future;

  void fetchTimetable() async {
    try {
      final timetable = await timetableUsecase.getTimetable(userId: userId);
      state = timetable;
      _completer.complete();
    } catch (e) {
      debugPrint(e.toString());
      _completer.completeError(e);
    }
  }

  Future<void> deleteTimetable({required ClassModel cls}) async {
    await waitForInitialization();
    state = await timetableUsecase.deleteTimetable(
      userId: userId,
      cls: cls,
      currentTimetable: state,
    );
  }

  Future<void> addTimetable({required ClassModel cls}) async {
    await waitForInitialization();
    state = await timetableUsecase.addTimetable(
      userId: userId,
      cls: cls,
      currentTimetable: state,
    );
  }
}
