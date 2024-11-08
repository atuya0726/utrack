enum TaskState {
  pending, // 未完了
  completed, // 完了
  inProgress, // 進行中
  canceled // キャンセル
}

class TaskModel {
  final int id;
  final int classId;
  final int userId;
  final String name;
  final DateTime deadline;
  final String howToSubmit;
  final TaskState state;

  TaskModel({
    required this.id,
    required this.classId,
    required this.userId,
    required this.name,
    required this.deadline,
    required this.howToSubmit,
    required this.state,
  });
}
