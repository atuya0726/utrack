import 'package:mockito/annotations.dart';
import 'package:utrack/usecase/class_usecase.dart';
import 'package:utrack/usecase/timetable_usecase.dart';
import 'package:utrack/usecase/task_usecase.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ClassUsecase>(),
  MockSpec<TimetableUsecase>(),
  MockSpec<TaskUsecase>(),
])
void main() {}
