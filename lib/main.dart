import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
