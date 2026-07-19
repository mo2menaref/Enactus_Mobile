import 'package:flutter/material.dart';
import '../models/task_models.dart';

// 2. The Screen Widget
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<TaskModel> myTasks = [
    TaskModel(title: "Design Database", taskName: '', assignedTo: ''),
    TaskModel(title: "Create API endpoints", isDone: true, taskName: '', assignedTo: ''),
    TaskModel(title: "Connect Firebase", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
    TaskModel(title: "Test Application", taskName: '', assignedTo: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enactus Tasks"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // 4. The Magic Widget: ListView.builder
      body: ListView.builder(
        itemCount: myTasks.length,
        itemBuilder: (context, index) {
          final task = myTasks[index];

          // 5. The UI for each row
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              // The Checkbox on the left
              leading: Checkbox(
                value: task.isDone,
                onChanged: (bool? newValue) {
                  // Rebuilding the UI when a task is checked/unchecked
                  setState(() {
                    task.isDone = newValue ?? false;
                  });
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  // Strike through if done
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: task.isDone ? Colors.grey : Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    myTasks.removeAt(index); // Deleting the task
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}