import 'package:utrack/model/class.dart';
import 'package:utrack/model/task.dart';

final classmodel = ClassModel(
  id: "test",
  name: "キャリア教育基礎",
  professor: "test",
  place: "東A-404",
  period: 4,
  dayOfWeek: "test",
  semester: "test",
  year: 3,
);

final classmodel_2 = ClassModel(
  id: "abcd",
  name: "Academic English for the Second Year Ⅰ（Ⅱ類・E）",
  professor: "test",
  place: "東A-4046666666",
  period: 4,
  dayOfWeek: "test",
  semester: "test",
  year: 3,
);

final task = TaskModel(
  id: 123,
  classId: 213,
  userId: 123,
  name: "レポート",
  deadline: DateTime(2024, 10, 02),
  howToSubmit: "online",
  state: TaskState.inProgress,
);

Map<String, Map<int, ClassModel?>> timetable = {
  'mon': {1: null, 2: classmodel, 3: null, 4: classmodel, 5: null},
  'tue': {1: null, 2: null, 3: classmodel_2, 4: null, 5: null},
  'wed': {1: null, 2: null, 3: classmodel, 4: classmodel, 5: null},
  'thu': {1: classmodel, 2: null, 3: classmodel, 4: null, 5: classmodel},
  'fri': {1: null, 2: classmodel, 3: null, 4: null, 5: null},
};

List<ClassModel> classes = [classmodel, classmodel];

List<TaskModel> tasks = [task, task];
