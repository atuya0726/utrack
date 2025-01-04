import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/timetable.dart';

import '../mock/firebase_mock.dart';
import '../mock/usecase.mocks.dart';
import '../mock/mock_variables.dart';

void main() {
  late TimetableNotifier timetableNotifier;
  late MockTimetableUsecase mockTimetableUsecase;
  late MockFirebaseAuth mockAuth;
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    mockAuth = MockFirebaseAuth(mockUser: MockUser(uid: 'test-user-id'));
    mockTimetableUsecase = MockTimetableUsecase();

    // モックの動作を設定
    when(mockTimetableUsecase.getTimetable(userId: anyNamed('userId')))
        .thenAnswer((_) async => mockTimetable);

    timetableNotifier = TimetableNotifier(
      timetableUsecase: mockTimetableUsecase,
      firebaseAuth: mockAuth,
    );
  });

  group('初期化テスト', () {
    test('初期化時に時間割を取得する', () async {
      await timetableNotifier.waitForInitialization();

      expect(timetableNotifier.state, mockTimetable);
      verify(mockTimetableUsecase.getTimetable(userId: anyNamed('userId')))
          .called(1);
    });

    test('初期化時にエラーが発生した場合、例外をスローする', () async {
      when(mockTimetableUsecase.getTimetable(userId: anyNamed('userId')))
          .thenThrow(Exception('Failed to fetch'));

      final errorTimetableNotifier = TimetableNotifier(
        timetableUsecase: mockTimetableUsecase,
        firebaseAuth: mockAuth,
      );

      await expectLater(
        errorTimetableNotifier.waitForInitialization(),
        throwsException,
      );
    });
  });

  group('時間割操作のテスト', () {
    setUp(() async {
      await timetableNotifier.waitForInitialization();
    });

    test('addTimetable - 正常系のテスト', () async {
      final testClass = ClassModel(
        id: 'new-class',
        name: 'テスト授業',
        professor: 'テスト教授',
        place: '1-101',
        period: [Period.first],
        dayOfWeek: Week.mon,
        semester: '前期',
        grade: [1],
        users: [],
      );

      final updatedTimetable =
          Map<Week, Map<Period, ClassModel?>>.from(mockTimetable);
      updatedTimetable[Week.mon]![Period.first] = testClass;

      when(mockTimetableUsecase.addTimetable(
        userId: anyNamed('userId'),
        cls: anyNamed('cls'),
        currentTimetable: anyNamed('currentTimetable'),
      )).thenAnswer((_) async => updatedTimetable);

      await timetableNotifier.addTimetable(cls: testClass);

      expect(
        timetableNotifier.state[Week.mon]![Period.first],
        testClass,
      );

      verify(mockTimetableUsecase.addTimetable(
        userId: anyNamed('userId'),
        cls: testClass,
        currentTimetable: anyNamed('currentTimetable'),
      )).called(1);
    });

    test('deleteTimetable - 正常系のテスト', () async {
      final testClass = classmodel;
      final initialTimetable =
          Map<Week, Map<Period, ClassModel?>>.from(mockTimetable);
      initialTimetable[testClass.dayOfWeek]![testClass.period.first] =
          testClass;

      final updatedTimetable =
          Map<Week, Map<Period, ClassModel?>>.from(initialTimetable);
      updatedTimetable[testClass.dayOfWeek]![testClass.period.first] = null;

      when(mockTimetableUsecase.getTimetable(userId: anyNamed('userId')))
          .thenAnswer((_) async => initialTimetable);

      when(mockTimetableUsecase.deleteTimetable(
        userId: anyNamed('userId'),
        cls: anyNamed('cls'),
        currentTimetable: anyNamed('currentTimetable'),
      )).thenAnswer((_) async => updatedTimetable);

      await timetableNotifier.deleteTimetable(cls: testClass);

      expect(
        timetableNotifier.state[testClass.dayOfWeek]![testClass.period.first],
        null,
      );

      verify(mockTimetableUsecase.deleteTimetable(
        userId: anyNamed('userId'),
        cls: testClass,
        currentTimetable: anyNamed('currentTimetable'),
      )).called(1);
    });
  });
}
