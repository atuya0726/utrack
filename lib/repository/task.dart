import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<TaskModel> docRef;

  TaskRepository() {
    docRef = _firestore.collection('tasks').withConverter(
          fromFirestore: TaskModel.fromFirestore,
          toFirestore: (TaskModel task, options) => task.toFirestore(),
        );
  }

  Future<void> addTask({required TaskModel task}) async {
    try {
      await docRef.doc(task.id).set(task);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to add task: $e');
    }
  }

  Future<void> deleteTask({required String taskId}) async {
    try {
      debugPrint(taskId);
      await docRef.doc(taskId).delete();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> deleteTasks({
    required String userId,
    required String classId,
    required Transaction transaction,
  }) async {
    try {
      final value = await docRef
          .where('userId', isEqualTo: userId)
          .where('classId', isEqualTo: classId)
          .get();

      if (value.docs.isNotEmpty) {
        // ドキュメントが存在する場合のみ削除を実行
        for (final doc in value.docs) {
          if (doc.reference.path.isNotEmpty) {
            // パスが空でないことを確認
            transaction.delete(doc.reference);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete tasks: $e');
    }
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    try {
      await docRef.doc(taskId).update({'status': status.name});
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to update task status: $e');
    }
  }

  Future<List<TaskModel>> getTasks({required String userId}) async {
    try {
      final querySnapshot =
          await docRef.where('userId', isEqualTo: userId).get();
      final tasks = querySnapshot.docs.map((doc) => doc.data()).toList();

      return tasks;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      throw Exception('Failed to fetch tasks: $e');
    }
  }
}
