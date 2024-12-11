import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/repository/class.dart';
import 'package:utrack/model/timetable.dart';
import 'package:utrack/repository/task.dart';
import 'package:utrack/repository/user.dart';

final timetableProvider = StateNotifierProvider<TimetableNotifier, Timetable>(
  (ref) => TimetableNotifier(),
);

class TimetableNotifier extends StateNotifier<Timetable> {
  final UserRepository userRepository = UserRepository();
  final ClassRepository classRepository = ClassRepository();
  final User? user;
  final String userId;

  TimetableNotifier()
      : user = FirebaseAuth.instance.currentUser,
        userId = FirebaseAuth.instance.currentUser?.uid ?? '',
        super(Timetable());

  void fetchTimetable() async {
    try {
      final userClasses = await userRepository.userClasses(userId: userId);
      state = await classRepository.fetchTimetableByClassIds(userClasses);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch timetable: $e');
    }
  }

  Future<void> addTimetable({required ClassModel cls}) async {
    state = TimetableModel().add(cls: cls, timetable: state);
    try {
      await userRepository.addUserClass(userId: userId, classId: cls.id);
    } catch (e) {
      debugPrint(e.toString());
      // エラー時は状態を元に戻す
      state = TimetableModel().delete(
        classId: cls.id,
        timetable: state,
        dayOfWeek: cls.dayOfWeek,
        periods: cls.period,
      );
      throw Exception('Failed to add timetable: $e');
    }
  }

  Future<bool> deleteTimetable({
    required ClassModel cls,
  }) async {
    final previousState = state;

    state = TimetableModel().delete(
      classId: cls.id,
      timetable: state,
      dayOfWeek: cls.dayOfWeek,
      periods: cls.period,
    );

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // ユーザーのクラス登録を削除
        await userRepository.deleteUserClass(
          userId: userId,
          classId: cls.id,
          transaction: transaction,
        );

        // クラスに関連するタスクを削除
        await TaskRepository().deleteTasks(
          userId: userId,
          classId: cls.id,
          transaction: transaction,
        );
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      state = previousState;
      return false;
    }
  }
}
