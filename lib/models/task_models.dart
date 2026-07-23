import 'dart:convert';

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

  // 1. Convert TaskModel to a Map (Serialization)
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'assignedTo': assignedTo,
      'title': title,
      'isDone': isDone,
    };
  }

  // 2. Create a TaskModel from a Map (Deserialization)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskName: map['taskName'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}