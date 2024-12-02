import 'package:utrack/constants.dart';
import 'package:utrack/viewmodel/class.dart';

class MockClassNotifier extends ClassNotifier {
  bool isCalled = false;
  Map<String, dynamic>? lastArgs;

  @override
  void filterClasses(
      {Grade? grade, required Period period, required Week dayOfWeek}) {
    isCalled = true;
    lastArgs = {'grade': grade, 'period': period, 'dayOfWeek': dayOfWeek};
  }

  @override
  void searchClasses(
      {required String text, required Week dayOfWeek, required Period period}) {
    isCalled = true;
    lastArgs = {'text': text, 'dayOfWeek': dayOfWeek, 'period': period};
  }

  @override
  String getNameById({required String classId}) {
    return 'class';
  }
}
