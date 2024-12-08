import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/theme.dart';
import 'package:utrack/util.dart';
import 'package:utrack/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Noto Sans JP", "Noto Sans JP");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'UTrack',
      theme: theme.light(),
      home: const Home(),
    );
  }
}
