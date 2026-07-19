import 'package:flutter/material.dart';
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
  // 1. Reusable method to show a confirmation dialog
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
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // 2. Method to actually delete the task and show a SnackBar
  void _deleteTask(int index) {
    final deletedTask = tasksList[index];
    setState(() {
      tasksList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted successfully!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 1),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              tasksList.insert(index, deletedTask);
            });
          },
        ),
      ),
    );
  }

  // 3. Method to update/edit a task's name using a Dialog
  void _editTask(int index) {
    TextEditingController editController = TextEditingController(
      text: tasksList[index].assignedTo,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task Name"),
          content: TextField(controller: editController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Creating a new task object with the updated name
                  tasksList[index] = TaskModel(
                    taskName: tasksList[index].taskName,
                    assignedTo: editController.text,
                    isDone: tasksList[index].isDone,
                  );
                });
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task updated!"),
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 2000),
                  ),
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
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  confirmDismiss: (direction) async {
                    return await _confirmDeletion(context);
                  },
                  onDismissed: (direction) {
                    _deleteTask(index);
                  },
                  child: Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      elevation: 6,
                      child: ListTile(
                        // Update Status (Checkbox)
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (bool? newValue) {
                            setState(() {
                              task.isDone = newValue ?? false;
                            });
                          },
                        ),
                        title: Text(
                          task.taskName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isDone ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: Text("Assigned to: ${task.assignedTo}"),

                        // Trailing holds BOTH Edit and Delete Buttons
                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min, // Keep icons tightly together
                          children: [
                            // 1. Edit Button
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTask(index),
                            ),
                            // 2. Delete Button (Manual tap)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool confirm =
                                    await _confirmDeletion(context) ?? false;
                                if (confirm) {
                                  _deleteTask(index);
                                }
                              },
                            ),
                          ],
                        ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Task added successfully!"),
                backgroundColor: Colors.teal,
              ),
            );
          }
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add New Task",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
