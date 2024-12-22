import 'package:mockito/annotations.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/viewmodel/timetable.dart';

@GenerateNiceMocks([
  MockSpec<TaskNotifier>(),
  MockSpec<ClassNotifier>(),
  MockSpec<TimetableNotifier>(),
])
void main() {}
