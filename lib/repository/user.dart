import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:utrack/model/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<UserModel> docRef;

  UserRepository() {
    docRef = _firestore.collection('users').withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel cls, options) => cls.toFirestore(),
        );
  }

  Future<void> makeUser({required UserModel user}) async {
    await docRef.doc(user.id).set(user);
  }

  Future<UserModel> getUser({required String userId}) async {
    final querySnapshot = await docRef.doc(userId).get();
    return querySnapshot.data() ?? UserModel.empty();
  }

  Future<List<String>> userClasses({required String userId}) async {
    try {
      final querySnapshot = await docRef.doc(userId).get();
      final user = querySnapshot.data();
      if (user == null) {
        throw Exception('User not found');
      }
      return user.classes;
    } catch (e, stackTrace) {
      debugPrint('Error fetching classes: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch classes: $e');
    }
  }

  Future<void> addUserClass(
      {required String userId, required String classId}) async {
    await docRef.doc(userId).update({
      'classes': FieldValue.arrayUnion([classId])
    });
  }

  Future<void> deleteUserClass(
      {required String userId,
      required String classId,
      required Transaction transaction}) async {
    transaction.update(
      docRef.doc(userId),
      {
        'classes': FieldValue.arrayRemove([classId])
      },
    );
  }

  Future<void> updateUser({required UserModel user}) async {
    await docRef.doc(user.id).update({
      'grade': user.grade?.index,
      'major': user.major?.index,
    });
  }
}
