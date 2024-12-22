import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/model/timetable.dart';
import 'package:utrack/repository/class.dart';
import 'package:utrack/repository/task.dart';
import 'package:utrack/repository/user.dart';
import 'package:utrack/constants.dart';

class ClassUsecase {
  final ClassRepository _classRepository;
  final UserRepository _userRepository;
  final TaskRepository _taskRepository;
  final TimetableModel _timetableModel;

  ClassUsecase({
    ClassRepository? classRepository,
    UserRepository? userRepository,
    TaskRepository? taskRepository,
    TimetableModel? timetableModel,
  })  : _classRepository = classRepository ?? ClassRepository(),
        _userRepository = userRepository ?? UserRepository(),
        _taskRepository = taskRepository ?? TaskRepository(),
        _timetableModel = timetableModel ?? TimetableModel();

  Future<List<ClassModel>> getAllClasses() async {
    return await _classRepository.fetchClasses();
  }

  Future<List<ClassModel>> searchClasses({
    required List<ClassModel> classes,
    required String text,
    required Week dayOfWeek,
    required Period period,
  }) async {
    final filteredClasses = await filterClasses(
      classes: classes,
      grade: null,
      period: period,
      dayOfWeek: dayOfWeek,
    );

    return filteredClasses
        .where((item) => item.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  Future<List<ClassModel>> filterClasses({
    required List<ClassModel> classes,
    required Grade? grade,
    required Period period,
    required Week dayOfWeek,
  }) async {
    return classes.where((element) {
      final matchesGrade =
          grade == null || element.grade.contains(grade.number);
      final matchesPeriod = element.period.contains(period);
      final matchesDay = element.dayOfWeek == dayOfWeek;

      return matchesGrade && matchesPeriod && matchesDay;
    }).toList();
  }

  Future<String> getClassNameById({
    required List<ClassModel> classes,
    required String classId,
  }) async {
    if (classes.isEmpty) {
      return '';
    }
    final cls = classes.firstWhere(
      (cls) => cls.id == classId,
      orElse: () => ClassModel.empty(),
    );
    return cls.name;
  }

  Future<Timetable> getTimetableByUserId(String userId) async {
    final userClasses = await _userRepository.userClasses(userId: userId);
    final classes = await _classRepository.fetchClassesByIds(
      classIds: userClasses,
    );
    return _timetableModel.generateTimetable(classes);
  }

  Future<void> addClassToTimetable({
    required String userId,
    required ClassModel cls,
  }) async {
    await _userRepository.addUserClass(userId: userId, classId: cls.id);
  }

  Future<void> deleteClassFromTimetable({
    required String userId,
    required ClassModel cls,
  }) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // ユーザーのクラス登録を削除
      await _userRepository.deleteUserClass(
        userId: userId,
        classId: cls.id,
        transaction: transaction,
      );

      // クラスに関連するタスクを削除
      await _taskRepository.deleteTasks(
        userId: userId,
        classId: cls.id,
        transaction: transaction,
      );
    });
  }
}
