import 'package:flutter/material.dart';
import 'package:utrack/theme.dart';
import 'package:utrack/util.dart';
import 'package:utrack/view/home.dart';

void main() {
  runApp(const MyApp());
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
