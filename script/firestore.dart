import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

Future<void> addClass(Map<String, dynamic> data) async {
  final admin = FirebaseAdminApp.initializeApp(
    'utrack-dev',
    Credential.fromServiceAccount(
      File('script/credential.json'),
    ),
  );

  final firestore = Firestore(admin);
  final collection = firestore.collection('classes');

  await collection.doc().set(data);

  await admin.close();
}