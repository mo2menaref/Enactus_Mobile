import 'package:flutter/material.dart';
import '../models/task_models.dart';
import '../service/firestore.dart';
import 'add_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String username;
  const TaskDetailsScreen({super.key, required this.username});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  // Notice there's no _loadTasksFromPrefs() / _saveTasksToPrefs() anymore,
  // and no local `tasksList` field either. The StreamBuilder below IS
  // the state now — Firestore pushes updates, we just render them.

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

  void _editTask(TaskModel task) {
    TextEditingController editController =
    TextEditingController(text: task.taskName);

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
                final updatedTask = TaskModel(
                  id: task.id,
                  taskName: editController.text,
                  assignedTo: task.assignedTo,
                  isDone: task.isDone,
                );
                _firestoreService.updateTask(widget.username, updatedTask);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Task updated!"),
                      backgroundColor: Colors.green),
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
        title: Text("Tasks for ${widget.username}"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<TaskModel>>(
        // This stream is the whole trick: Firestore keeps this connection
        // open and re-emits the full task list on every change, so the UI
        // updates itself with zero manual setState() calls for the list.
        stream: _firestoreService.getTasksStream(widget.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong: ${snapshot.error}"));
          }

          final tasksList = snapshot.data ?? [];

          if (tasksList.isEmpty) {
            return const Center(
              child: Text(
                "No tasks assigned yet. Add one below!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasksList.length,
            itemBuilder: (context, index) {
              final task = tasksList[index];

              return Dismissible(
                key: ValueKey(task.id),
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
                  _firestoreService.deleteTask(widget.username, task.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Task deleted successfully!"),
                        backgroundColor: Colors.redAccent),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (bool? newValue) {
                        _firestoreService.toggleDone(
                            widget.username, task.id!, newValue ?? false);
                      },
                    ),
                    title: Text(
                      task.taskName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration:
                        task.isDone ? TextDecoration.lineThrough : null,
                        color: task.isDone ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text("Assigned to: ${task.assignedTo}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editTask(task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirm = await _confirmDeletion(context) ?? false;
                            if (confirm) {
                              _firestoreService.deleteTask(
                                  widget.username, task.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
            // Just write to Firestore — the StreamBuilder above will
            // pick up the change and rebuild the list automatically.
            await _firestoreService.addTask(widget.username, newTask);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Task added successfully!"),
                  backgroundColor: Colors.teal),
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