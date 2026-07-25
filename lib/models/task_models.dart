class TaskModel {

  final String? id;
  final String taskName;
  final String assignedTo;
  final String title;
  bool isDone;

  TaskModel({
    this.id,
    required this.taskName,
    required this.assignedTo,
    this.title = '',
    this.isDone = false,
  });
}