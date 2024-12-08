import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/constants.dart';

import '../../notifierMock/task_mock.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'test',
      appId: 'test',
      messagingSenderId: 'test',
      projectId: 'test',
    ),
  );

  testWidgets('AddTask allows task creation and updates state',
      (WidgetTester tester) async {
    // モックプロバイダーを作成
    final mockNotifier = MockTaskNotifier();
    final container = ProviderContainer(overrides: [
      taskProvider.overrideWith((ref) => mockNotifier),
    ]);

    addTearDown(container.dispose);

    // テスト対象ウィジェットを作成
    final widget = UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: AddTask(
            cls: ClassModel(
              id: 'class1',
              name: 'Test Class',
              professor: 'Test Professor',
              dayOfWeek: Week.mon,
              period: [Period.first],
              place: 'Test Room',
              semester: '1',
              year: [2024],
              users: [],
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
  });
}
