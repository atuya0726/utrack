import 'package:mockito/annotations.dart';
import 'package:utrack/repository/class.dart';
import 'package:utrack/repository/user.dart';
import 'package:utrack/repository/task.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ClassRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<TaskRepository>(),
])
void main() {}
