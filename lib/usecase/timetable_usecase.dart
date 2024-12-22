import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/model/timetable.dart';
import 'package:utrack/repository/class.dart';
import 'package:utrack/repository/task.dart';
import 'package:utrack/repository/user.dart';

class TimetableUsecase {
  final ClassRepository _classRepository;
  final UserRepository _userRepository;
  final TaskRepository _taskRepository;
  final TimetableModel _timetableModel;

  TimetableUsecase({
    ClassRepository? classRepository,
    UserRepository? userRepository,
    TaskRepository? taskRepository,
    TimetableModel? timetableModel,
  })  : _classRepository = classRepository ?? ClassRepository(),
        _userRepository = userRepository ?? UserRepository(),
        _taskRepository = taskRepository ?? TaskRepository(),
        _timetableModel = timetableModel ?? TimetableModel();

  Future<Timetable> getTimetable({required String userId}) async {
    final userClasses = await _userRepository.userClasses(userId: userId);
    final classes =
        await _classRepository.fetchClassesByIds(classIds: userClasses);
    return _timetableModel.generateTimetable(classes);
  }

  Future<Timetable> deleteTimetable({
    required String userId,
    required ClassModel cls,
    required Timetable currentTimetable,
  }) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await _userRepository.deleteUserClass(
          userId: userId,
          classId: cls.id,
          transaction: transaction,
        );
        await _taskRepository.deleteTasks(
          userId: userId,
          classId: cls.id,
          transaction: transaction,
        );
      });
      final newTimetable = _timetableModel.delete(
        classId: cls.id,
        timetable: currentTimetable,
        dayOfWeek: cls.dayOfWeek,
        periods: cls.period,
      );
      return newTimetable;
    } catch (e) {
      return currentTimetable;
    }
  }

  Future<Timetable> addTimetable({
    required String userId,
    required ClassModel cls,
    required Timetable currentTimetable,
  }) async {
    await _userRepository.addUserClass(
      userId: userId,
      classId: cls.id,
    );
    final newTimetable = _timetableModel.add(
      timetable: currentTimetable,
      cls: cls,
    );
    return newTimetable;
  }
}
