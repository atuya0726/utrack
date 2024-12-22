import 'package:clock/clock.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/viewmodel/task.dart';
import '../mock/firebase_mock.dart';
import '../mock/usecase.mocks.dart';
import '../mock/mock_variables.dart';

void main() {
  late TaskNotifier taskNotifier;
  late MockTaskUsecase mockUsecase;
  late DateTime fixedTime;
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    final mockUser = MockUser(uid: 'test-user-id');
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    mockUsecase = MockTaskUsecase();
    when(mockUsecase.getAllTasks(userId: anyNamed('userId')))
        .thenAnswer((_) async => mockTasks);
    when(mockUsecase.updateTaskStatus(
      taskId: anyNamed('taskId'),
      status: anyNamed('status'),
      currentTasks: anyNamed('currentTasks'),
    )).thenAnswer((invocation) async {
      final taskId =
          invocation.namedArguments[const Symbol('taskId')] as String;
      final newStatus =
          invocation.namedArguments[const Symbol('status')] as TaskStatus;

      return mockTasks.map((task) {
        if (task.id == taskId) {
          return task.copyWith(status: newStatus);
        }
        return task;
      }).toList();
    });

    taskNotifier = TaskNotifier(
      taskUsecase: mockUsecase,
      firebaseAuth: mockAuth,
    );
    fixedTime = DateTime(2024, 1, 1, 12, 0);
    taskNotifier.originTasks = mockTasks;
    taskNotifier.state = mockTasks;
  });

  group('TaskNotifier Tests', () {
    test('calcRemainingDays - usecaseの呼び出しテスト', () {
      when(mockUsecase.calculateRemainingTime(
        deadline: anyNamed('deadline'),
      )).thenReturn('30分後');

      final deadline = fixedTime.add(const Duration(minutes: 30));
      taskNotifier.calcRemainingDays(datetime: deadline);

      verify(mockUsecase.calculateRemainingTime(
        deadline: deadline,
      )).called(1);
    });

    test('addTask - 正常系のテスト', () async {
      // モックの戻り値を設定
      final newTask = TaskModel(
        userId: 'test-user-id',
        id: 'new-task-id',
        status: TaskStatus.inProgress,
        classId: 'new-class-id',
        name: 'New Task',
        deadline: fixedTime,
        howToSubmit: HowToSubmit.offline,
      );
      when(mockUsecase.addTask(
        userId: anyNamed('userId'),
        classId: anyNamed('classId'),
        name: anyNamed('name'),
        deadline: anyNamed('deadline'),
        howToSubmit: anyNamed('howToSubmit'),
        currentTasks: anyNamed('currentTasks'),
      )).thenAnswer((_) async => [...mockTasks, newTask]);

      // メソッドを実行
      await taskNotifier.addTask(
        classId: 'new-class-id',
        name: 'New Task',
        deadline: fixedTime,
        howToSubmit: HowToSubmit.offline,
      );

      // usecaseが正しく呼ばれたことを確認
      verify(mockUsecase.addTask(
        userId: 'test-user-id',
        classId: 'new-class-id',
        name: 'New Task',
        deadline: fixedTime,
        howToSubmit: HowToSubmit.offline,
        currentTasks: mockTasks,
      )).called(1);

      // stateが更新されたことを確認
      expect(taskNotifier.state, contains(newTask));
    });

    test('filterTasks - クラスIDでフィルタリング', () async {
      // モックの戻り値を設定
      final filteredTasks =
          mockTasks.where((task) => task.classId == 'test').toList();
      when(mockUsecase.filterTasks(
        tasks: anyNamed('tasks'),
        classId: anyNamed('classId'),
        status: anyNamed('status'),
      )).thenAnswer((_) => filteredTasks);

      // メソッドを実行
      await taskNotifier.filterTasks(classId: 'test');

      // usecaseが正しく呼び出されたことを確認
      verify(mockUsecase.filterTasks(
        tasks: mockTasks,
        classId: 'test',
        status: null,
      )).called(1);

      // stateが更新されたことを確認
      expect(taskNotifier.state, equals(filteredTasks));
    });

    test('nextWeekAt2359 - 次週の木曜日23:59を計算', () {
      // モックの戻り値を設定
      final expectedDateTime = DateTime(2024, 1, 11, 23, 59);
      when(mockUsecase.calculateNextWeekAt2359(
        dayOfWeek: anyNamed('dayOfWeek'),
      )).thenAnswer((_) => expectedDateTime);

      withClock(Clock.fixed(fixedTime), () {
        // メソッドを実行
        final result = taskNotifier.nextWeekAt2359(dayOfWeek: Week.thu);

        // usecaseが正しく呼び出されたことを確認
        verify(mockUsecase.calculateNextWeekAt2359(
          dayOfWeek: Week.thu,
        )).called(1);

        // 戻り値を確認
        expect(result, expectedDateTime);
      });
    });

    test('nextWeekClassStartTime - 次週の授業開始時刻を計算', () {
      // モックの戻り値を設定
      final expectedDateTime = DateTime(2024, 1, 10, 9, 0);
      when(mockUsecase.calculateNextWeekClassStartTime(
        dayOfWeek: anyNamed('dayOfWeek'),
        period: anyNamed('period'),
      )).thenAnswer((_) => expectedDateTime);

      withClock(Clock.fixed(fixedTime), () {
        // メソッドを実行
        final result = taskNotifier.nextWeekClassStartTime(
          dayOfWeek: Week.wed,
          period: Period.first,
        );

        // usecaseが正しく呼び出されたことを確認
        verify(mockUsecase.calculateNextWeekClassStartTime(
          dayOfWeek: Week.wed,
          period: Period.first,
        )).called(1);

        // 戻り値を確認
        expect(result, expectedDateTime);
      });
    });

    test('updateTaskStatus - タスクのステータス更新テスト', () async {
      // モックの戻り値を設定
      const String taskId = 'task1';
      const TaskStatus newStatus = TaskStatus.completed;
      final updatedTasks = mockTasks.map((task) {
        if (task.id == taskId) {
          return task.copyWith(status: newStatus);
        }
        return task;
      }).toList();

      when(mockUsecase.updateTaskStatus(
        taskId: anyNamed('taskId'),
        status: anyNamed('status'),
        currentTasks: anyNamed('currentTasks'),
      )).thenAnswer((_) async => updatedTasks);

      // メソッドを実行
      await taskNotifier.updateTaskStatus(
        taskId: taskId,
        status: newStatus,
      );

      // usecaseが正しく呼び出されたことを確認
      verify(mockUsecase.updateTaskStatus(
        taskId: taskId,
        status: newStatus,
        currentTasks: anyNamed('currentTasks'),
      )).called(1);

      // stateが更新されたことを確認
      expect(taskNotifier.state, equals(updatedTasks));
    });
  });
}
