import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/model/class.dart';
import 'package:flutter/foundation.dart';
import 'package:utrack/model/timetable.dart';

class ClassRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<ClassModel> docRef;

  ClassRepository() {
    docRef = _firestore.collection('classes').withConverter(
          fromFirestore: ClassModel.fromFirestore,
          toFirestore: (ClassModel cls, options) => cls.toFirestore(),
        );
  }

  Future<List<ClassModel>> fetchClasses() async {
    try {
      final querySnapshot = await docRef.get();
      final classes = querySnapshot.docs.map((doc) => doc.data()).toList();

      return classes;
    } catch (e, stackTrace) {
      debugPrint('Error fetching classes: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch classes: $e');
    }
  }

  Future<Timetable> fetchTimetableByClassIds(List<String> classIds) async {
    final querySnapshot =
        await docRef.where(FieldPath.documentId, whereIn: classIds).get();
    final classes = querySnapshot.docs.map((doc) => doc.data()).toList();

    return TimetableModel().generateTimetable(classes);
  }

  Future<void> add(ClassModel cls) async {
    await docRef.add(cls);
  }
}
