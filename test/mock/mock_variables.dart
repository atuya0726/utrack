import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/model/task.dart';

final classmodel = ClassModel(
  id: "test",
  name: "キャリア教育基礎",
  professor: "test",
  place: "東A-404",
  period: [Period.fourth],
  dayOfWeek: Week.wed,
  semester: "test",
  grade: [3],
  users: [],
);

final classmodel_2 = ClassModel(
  id: "abcd",
  name: "Academic English for the Second Year Ⅰ（Ⅱ類・E）",
  professor: "test",
  place: "東A-4046666666",
  period: [Period.fourth],
  dayOfWeek: Week.mon,
  semester: "test",
  grade: [3],
  users: [],
);

final classmodel_3 = ClassModel(
  id: 'class3',
  name: 'データベース',
  professor: 'test',
  place: '西2-501',
  period: [Period.third],
  dayOfWeek: Week.mon,
  semester: 'test',
  grade: [2],
  users: [],
);

final classmodel_4 = ClassModel(
  id: 'class4',
  name: 'ネットワーク工学',
  professor: 'test',
  place: '東3-201',
  period: [Period.fourth],
  dayOfWeek: Week.tue,
  semester: 'test',
  grade: [3],
  users: [],
);

final classmodel_5 = ClassModel(
  id: 'class5',
  name: '情報セキュリティ',
  professor: 'test',
  place: '西5-201',
  period: [Period.first],
  dayOfWeek: Week.wed,
  semester: 'test',
  grade: [4],
  users: [],
);

final classmodel_6 = ClassModel(
  id: 'class6',
  name: 'アルゴリズム',
  professor: 'test',
  place: '東2-301',
  period: [Period.fifth],
  dayOfWeek: Week.thu,
  semester: 'test',
  grade: [2],
  users: [],
);

final classmodel_7 = ClassModel(
  id: 'class7',
  name: '人工知能',
  professor: 'test',
  place: '西3-401',
  period: [Period.third],
  dayOfWeek: Week.fri,
  semester: 'test',
  grade: [3],
  users: [],
);

final classmodel_8 = ClassModel(
  id: 'class8',
  name: '人工知能基礎',
  professor: 'test',
  place: '西3-402',
  period: [Period.third],
  dayOfWeek: Week.fri,
  semester: 'test',
  grade: [1],
  users: [],
);

final classmodel_9 = ClassModel(
  id: 'class9',
  name: '応用人工知能',
  professor: 'test',
  place: '西3-403',
  period: [Period.third],
  dayOfWeek: Week.fri,
  semester: 'test',
  grade: [1],
  users: [],
);

final classmodel_10 = ClassModel(
  id: 'class10',
  name: '人工知能特論',
  professor: 'test',
  place: '西3-404',
  period: [Period.third],
  dayOfWeek: Week.fri,
  semester: 'test',
  grade: [4],
  users: [],
);

List<ClassModel> mockClasses = [
  classmodel,
  classmodel_2,
  classmodel_3,
  classmodel_4,
  classmodel_5,
  classmodel_6,
  classmodel_7,
  classmodel_8,
  classmodel_9,
  classmodel_10
];

final task = TaskModel(
  id: '123',
  classId: 'test',
  userId: '123',
  name: "レポート",
  deadline: DateTime(2024, 12, 02),
  howToSubmit: HowToSubmit.online,
  status: TaskStatus.inProgress,
);

final task1 = TaskModel(
  id: 'task1',
  classId: 'test',
  userId: '123',
  name: "期末レポート",
  deadline: DateTime(2024, 11, 31),
  howToSubmit: HowToSubmit.offline,
  status: TaskStatus.inProgress,
);

final task2 = TaskModel(
  id: 'task2',
  classId: 'abcd',
  userId: '123',
  name: "Presentation Slides",
  deadline: DateTime(2024, 11, 26, 23, 59),
  howToSubmit: HowToSubmit.posting,
  status: TaskStatus.inProgress,
);

final task3 = TaskModel(
  id: 'task3',
  classId: 'test',
  userId: '123',
  name: "グループワーク資料作成",
  deadline: DateTime(2024, 11, 30),
  howToSubmit: HowToSubmit.offline,
  status: TaskStatus.inProgress,
);

Map<Week, Map<Period, ClassModel?>> mockTimetable = {
  Week.mon: {
    Period.first: null,
    Period.second: classmodel,
    Period.third: null,
    Period.fourth: classmodel,
    Period.fifth: null,
    Period.other: null,
  },
  Week.tue: {
    Period.first: null,
    Period.second: null,
    Period.third: classmodel_2,
    Period.fourth: null,
    Period.fifth: null,
    Period.other: null,
  },
  Week.wed: {
    Period.first: null,
    Period.second: null,
    Period.third: classmodel,
    Period.fourth: classmodel,
    Period.fifth: null,
    Period.other: null,
  },
  Week.thu: {
    Period.first: classmodel,
    Period.second: null,
    Period.third: classmodel,
    Period.fourth: null,
    Period.fifth: classmodel,
    Period.other: null,
  },
  Week.fri: {
    Period.first: null,
    Period.second: classmodel,
    Period.third: null,
    Period.fourth: null,
    Period.fifth: null,
    Period.other: null,
  },
};

List<TaskModel> mockTasks = [task, task1, task2, task3];
