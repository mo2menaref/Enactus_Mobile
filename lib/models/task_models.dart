class TaskModel {
  final String taskName;
  final String assignedTo;
  final String title;
  bool isDone;

  TaskModel({
    required this.taskName,
    required this.assignedTo,
    this.title = '',
    this.isDone = false,
  });
}