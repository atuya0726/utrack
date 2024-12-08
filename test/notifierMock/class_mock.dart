import 'package:utrack/constants.dart';
import 'package:utrack/viewmodel/class.dart';

class MockClassNotifier extends ClassNotifier {
  bool isCalled = false;
  Map<String, dynamic>? lastArgs;

  @override
  Future<void> filterClasses(
      {Grade? grade, required Period period, required Week dayOfWeek}) async {
    isCalled = true;
    lastArgs = {'grade': grade, 'period': period, 'dayOfWeek': dayOfWeek};
  }

  @override
  Future<void> searchClasses(
      {required String text,
      required Week dayOfWeek,
      required Period period}) async {
    isCalled = true;
    lastArgs = {'text': text, 'dayOfWeek': dayOfWeek, 'period': period};
  }

  @override
  Future<String> getNameById({required String classId}) async {
    return 'class';
  }
}
