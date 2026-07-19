import 'package:flutter/material.dart';
import '../models/task_models.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controllers: The bridge to read data from TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree
    nameController.dispose();
    personController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign a Task"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The Text Inputs
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Task Name (e.g., Design UI)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: personController,
                decoration: const InputDecoration(
                  labelText: "Assigned To (e.g., Ahmed)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an assignee';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  // Validate the form to ensure fields are not empty
                  if (_formKey.currentState!.validate()) {
                    // Create a new task object using data from the controllers
                    final newTask = TaskModel(
                      taskName: nameController.text,
                      assignedTo: personController.text,
                    );

                    // Return the newly created task back to the TaskDetailsScreen
                    Navigator.pop(context, newTask);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Assign Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}