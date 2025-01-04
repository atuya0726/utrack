import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/timetable.dart';
import 'package:utrack/repository/class.dart';
import 'package:utrack/repository/user.dart';
import 'package:utrack/usecase/class_usecase.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:mockito/mockito.dart';
import '../mock/firebase_mock.dart';
import '../mock/model.mocks.dart';
import '../mock/repository.mocks.dart';
import '../mock/mock_variables.dart';

void main() {
  late ClassNotifier classNotifier;
  late ClassRepository mockClassRepository;
  late UserRepository mockUserRepository;
  late TimetableModel mockTimetableModel;
  late ClassUsecase classUsecase;
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    mockClassRepository = MockClassRepository();
    mockUserRepository = MockUserRepository();
    mockTimetableModel = MockTimetableModel();

    when(mockClassRepository.fetchClasses())
        .thenAnswer((_) async => mockClasses);

    classUsecase = ClassUsecase(
      classRepository: mockClassRepository,
      userRepository: mockUserRepository,
      timetableModel: mockTimetableModel,
    );

    classNotifier = ClassNotifier(
      classUsecase: classUsecase,
    );
  });

  group('初期化テスト', () {
    test('初期化時に授業一覧を取得する', () async {
      // fetchClassesが呼ばれることを確認
      verify(mockClassRepository.fetchClasses()).called(1);

      // 初期化完了を待機
      await classNotifier.waitForInitialization();

      // stateが正しく設定されていることを確認
      expect(classNotifier.state, mockClasses);
      expect(classNotifier.originClasses, mockClasses);
    });

    test('初期化時にエラーが発生した場合、空の配列を設定する', () async {
      // モックの設定を変更
      when(mockClassRepository.fetchClasses())
          .thenThrow(Exception('Failed to fetch'));

      // 新しいインスタンスを作成
      final errorClassNotifier = ClassNotifier(
        classUsecase: classUsecase,
      );

      // エラーが発生することを確認
      expect(
        errorClassNotifier.waitForInitialization(),
        throwsException,
      );

      // stateが空配列になっていることを確認
      expect(errorClassNotifier.state, []);
      expect(errorClassNotifier.originClasses, []);
    });
  });

  group('検索機能のテスト', () {
    setUp(() async {
      await classNotifier.waitForInitialization();
    });

    test('searchClasses - 授業名で検索（完全一致）', () async {
      await classNotifier.searchClasses(
        text: 'データベース',
        dayOfWeek: Week.mon,
        period: Period.third,
      );

      expect(classNotifier.state.length, 1);
      expect(classNotifier.state.first.name, 'データベース');
    });

    test('searchClasses - 授業名で検索（部分一致）', () async {
      await classNotifier.searchClasses(
        text: '人工知能',
        dayOfWeek: Week.fri,
        period: Period.third,
      );

      expect(classNotifier.state.length, 4);
      expect(
        classNotifier.state.every((cls) => cls.name.contains('人工知能')),
        true,
      );
    });

    test('searchClasses - 大文字小文字を区別しない', () async {
      await classNotifier.searchClasses(
        text: 'academic',
        dayOfWeek: Week.mon,
        period: Period.fourth,
      );

      expect(classNotifier.state.length, 1);
      expect(
        classNotifier.state.first.name,
        'Academic English for the Second Year Ⅰ（Ⅱ類・E）',
      );
    });

    test('searchClasses - 該当する授業がない場合', () async {
      await classNotifier.searchClasses(
        text: '存在しない授業',
        dayOfWeek: Week.fri,
        period: Period.third,
      );

      expect(classNotifier.state.length, 0);
    });
  });

  group('フィルタリング機能のテスト', () {
    setUp(() async {
      await classNotifier.waitForInitialization();
    });

    test('filterClasses - 学年でフィルタリング（1年生）', () async {
      await classNotifier.filterClasses(
        grade: Grade.firstYear,
        period: Period.third,
        dayOfWeek: Week.fri,
      );

      expect(classNotifier.state.length, 2);
      expect(
        classNotifier.state
            .every((cls) => cls.grade.contains(Grade.firstYear.number)),
        true,
      );
    });

    test('filterClasses - 学年でフィルタリング（4年生）', () async {
      await classNotifier.filterClasses(
        grade: Grade.fourthYear,
        period: Period.third,
        dayOfWeek: Week.fri,
      );

      expect(classNotifier.state.length, 1);
      expect(
        classNotifier.state
            .every((cls) => cls.grade.contains(Grade.fourthYear.number)),
        true,
      );
    });

    test('filterClasses - gradeがnullの場合は全学年を表示', () async {
      await classNotifier.filterClasses(
        grade: null,
        period: Period.third,
        dayOfWeek: Week.fri,
      );

      final originalCount = mockClasses
          .where((cls) =>
              cls.period.contains(Period.third) && cls.dayOfWeek == Week.fri)
          .length;
      expect(classNotifier.state.length, originalCount);
    });

    test('filterClasses - 該当する授業がない場合', () async {
      await classNotifier.filterClasses(
        grade: Grade.firstYear,
        period: Period.first,
        dayOfWeek: Week.mon,
      );

      expect(classNotifier.state.length, 0);
    });
  });

  group('授業名取得機能のテスト', () {
    setUp(() async {
      await classNotifier.waitForInitialization();
    });

    test('getNameById - 存在する授業IDで名前を取得', () async {
      final className = await classNotifier.getNameById(classId: 'test');
      expect(className, 'キャリア教育基礎');
    });

    test('getNameById - 存在しない授業IDで空文字を返す', () async {
      final className =
          await classNotifier.getNameById(classId: 'non-existent');
      expect(className, '');
    });

    test('getNameById - originClassesが空の場合', () async {
      classNotifier.originClasses = [];
      final className = await classNotifier.getNameById(classId: 'test');
      expect(className, '');
    });
  });
}
