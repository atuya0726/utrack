import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/theme.dart';
import 'package:utrack/util.dart';
import 'package:utrack/view/Auth/AuthWrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  print("main");
  WidgetsFlutterBinding.ensureInitialized();
  print("main2");
  await dotenv.load(fileName: ".env");
  print("main3");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("main4");
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
