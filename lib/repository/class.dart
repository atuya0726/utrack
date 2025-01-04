import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/model/class.dart';
import 'package:flutter/foundation.dart';

class ClassRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<ClassModel> docRef;

  ClassRepository() {
    docRef = _firestore.collection('uec/2024/classes').withConverter(
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

  Future<List<ClassModel>> fetchClassesByIds({
    required List<String> classIds,
  }) async {
    if (classIds.isEmpty) {
      return [];
    }
    final querySnapshot =
        await docRef.where(FieldPath.documentId, whereIn: classIds).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> add(ClassModel cls) async {
    await docRef.add(cls);
  }
}
