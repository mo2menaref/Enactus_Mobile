import 'dart:convert'; // Required for jsonEncode and jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import package
import '../models/task_models.dart';
import 'add_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  // Our in-memory database
  List<TaskModel> tasksList = [];

  @override
  void initState() {
    super.initState();
    _loadTasksFromPrefs();
  }

  // 1. Load tasks from local storage
  Future<void> _loadTasksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('enactus_tasks_key');

    if (tasksString != null) {
      // Decode the string back to a List of raw Maps
      final List<dynamic> decodedList = jsonDecode(tasksString);

      setState(() {
        // Convert raw Maps back to TaskModel objects
        tasksList = decodedList.map((item) => TaskModel.fromMap(item)).toList();
      });
    }
  }

  // 2. Save current list to local storage
  Future<void> _saveTasksToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert our list of objects into a list of maps, then encode to a single JSON string
    final String encodedData = jsonEncode(
      tasksList.map((task) => task.toMap()).toList(),
    );

    await prefs.setString('enactus_tasks_key', encodedData);
  }

  Future<bool?> _confirmDeletion(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task?"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    final deletedTask = tasksList[index];
    setState(() {
      tasksList.removeAt(index);
    });

    _saveTasksToPrefs(); // SYNC WITH LOCAL STORAGE

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted successfully!"),
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              tasksList.insert(index, deletedTask);
            });
            _saveTasksToPrefs(); // SYNC WITH LOCAL STORAGE ON UNDO
          },
        ),
      ),
    );
  }

  void _editTask(int index) {
    TextEditingController editController = TextEditingController(text: tasksList[index].taskName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task Name"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasksList[index] = TaskModel(
                    taskName: editController.text,
                    assignedTo: tasksList[index].assignedTo,
                    isDone: tasksList[index].isDone,
                  );
                });

                _saveTasksToPrefs(); // SYNC WITH LOCAL STORAGE ON EDIT

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task updated!"), backgroundColor: Colors.green),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enactus Task Manager"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: tasksList.isEmpty
          ? const Center(
        child: Text(
          "No tasks assigned yet. Add one below!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: tasksList.length,
        itemBuilder: (context, index) {
          final task = tasksList[index];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            confirmDismiss: (direction) async {
              return await _confirmDeletion(context);
            },
            onDismissed: (direction) {
              _deleteTask(index);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              elevation: 3,
              child: ListTile(
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? newValue) {
                    setState(() {
                      task.isDone = newValue ?? false;
                    });
                    _saveTasksToPrefs(); // SYNC WITH LOCAL STORAGE ON STATUS TOGGLE
                  },
                ),
                title: Text(
                  task.taskName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                    color: task.isDone ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text("Assigned to: ${task.assignedTo}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editTask(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool confirm = await _confirmDeletion(context) ?? false;
                        if (confirm) {
                          _deleteTask(index);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final TaskModel? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (newTask != null) {
            setState(() {
              tasksList.add(newTask);
            });

            _saveTasksToPrefs(); // SYNC WITH LOCAL STORAGE ON ADDITION

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Task added successfully!"), backgroundColor: Colors.teal),
            );
          }
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add New Task", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}