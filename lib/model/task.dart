enum TaskState {
  pending, // 未完了
  completed, // 完了
  inProgress, // 進行中
  canceled // キャンセル
}

class TaskModel {
  final String id;
  final String classId;
  final String userId;
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
