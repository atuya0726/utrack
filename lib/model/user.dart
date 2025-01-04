import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/model/constants.dart';

class UserModel {
  final String id;
  final List<String> classes;
  final Grade? grade;
  final Major? major;

  UserModel({
    required this.id,
    required this.classes,
    this.grade,
    this.major,
  });

  static UserModel empty() {
    return UserModel(id: '', classes: []);
  }

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final Map<String, dynamic> data = snapshot.data() ?? {};
    final String id = snapshot.id;
    return UserModel(
      id: id,
      classes: data['classes'].cast<String>() ?? [],
      grade: data['grade'] != null ? Grade.values[data['grade']] : null,
      major: data['major'] != null ? Major.values[data['major']] : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'classes': classes,
        'grade': grade?.index,
        'major': major?.index,
      };

  UserModel copyWith({
    Grade? grade,
    Major? major,
  }) {
    return UserModel(
      id: id,
      classes: classes,
      grade: grade,
      major: major,
    );
  }
}
