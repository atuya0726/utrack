import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/constants.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String classId;
  final String userId;
  final String name;
  final DateTime deadline;
  final HowToSubmit howToSubmit;
  TaskStatus status;

  TaskModel({
    required this.id,
    required this.classId,
    required this.userId,
    required this.name,
    required this.deadline,
    required this.howToSubmit,
    required this.status,
  });

  factory TaskModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data()!;
    return TaskModel(
      id: doc.id,
      classId: data['classId'],
      userId: data['userId'],
      name: data['name'],
      deadline: data['deadline'].toDate(),
      howToSubmit: HowToSubmit.values.byName(data['howToSubmit'] as String),
      status: TaskStatus.values.byName(data['status'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'classId': classId,
      'userId': userId,
      'name': name,
      'deadline': deadline,
      'howToSubmit': howToSubmit.name,
      'status': status.name,
    };
  }

  static TaskModel addTask(
      {required String classId,
      required String name,
      required String userId,
      required DateTime deadline,
      required HowToSubmit howToSubmit,
      required TaskStatus status}) {
    return TaskModel(
      id: const Uuid().v4(),
      classId: classId,
      userId: userId,
      name: name,
      deadline: deadline,
      howToSubmit: howToSubmit,
      status: status,
    );
  }

  static Map<String, List<TaskModel>> listToMap(List<TaskModel> tasks) {
    return tasks.fold<Map<String, List<TaskModel>>>(
      {},
      (map, task) {
        if (!map.containsKey(task.classId)) {
          map[task.classId] = [];
        }
        map[task.classId]!.add(task);
        return map;
      },
    );
  }

  TaskModel copyWith({
    String? id,
    String? classId,
    String? userId,
    String? name,
    DateTime? deadline,
    HowToSubmit? howToSubmit,
    TaskStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      deadline: deadline ?? this.deadline,
      howToSubmit: howToSubmit ?? this.howToSubmit,
      status: status ?? this.status,
    );
  }
}
