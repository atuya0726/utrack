// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utrack/utils/theme.dart';
import 'package:utrack/utils/util.dart';
import 'package:utrack/view/Auth/AuthWrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    Firebase.app(); // 既に初期化されている場合は既存のインスタンスを取得
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

  String? token = await messaging.getToken();
  print("token: $token");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('通知を受信しました: ${message.notification?.title}');
  });

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Noto Sans JP", "Noto Sans JP");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'UTrack',
      theme: theme.light(),
      home: const AuthWrapper(),
    );
  }
}
