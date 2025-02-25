import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utrack/usecase/fcm_usecase.dart';
import 'package:utrack/view/Auth/login.dart';
import 'package:utrack/view/home.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final userId = snapshot.data!.uid;
          NotificationUseCase().initialize(userId);

          // ユーザーがログインしている場合
          return const HomePage();
        }

        // ユーザーがログインしていない場合
        return LoginPage();
      },
    );
  }
}
