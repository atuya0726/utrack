import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final List<String> classes;

  UserModel({required this.id, required this.classes});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final Map<String, dynamic> data = snapshot.data() ?? {};
    final String id = snapshot.id;
    return UserModel(id: id, classes: data['classes'].cast<String>() ?? []);
  }

  Map<String, dynamic> toFirestore() => {'classes': classes};
}
