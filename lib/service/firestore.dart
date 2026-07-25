import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _tasksRef(String username) {
    return _db.collection('users').doc(username).collection('tasks');
  }

  CollectionReference<Map<String, dynamic>> _profRef(String username) {
    return _db.collection('users').doc(username).collection('profile');
  }

  Stream<List<TaskModel>> getTasksStream(String username) {
    return _tasksRef(username)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return TaskModel(
        id: doc.id,
        taskName: data['taskName'] ?? '',
        assignedTo: data['assignedTo'] ?? '',
        title: data['title'] ?? '',
        isDone: data['isDone'] ?? false,
      );
    }).toList());
  }

  Future<void> addTask(String username, TaskModel task) async {
    await _tasksRef(username).add({
      'taskName': task.taskName,
      'assignedTo': task.assignedTo,
      'title': task.title,
      'isDone': task.isDone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(String username, TaskModel task) async {
    if (task.id == null) return;
    await _tasksRef(username).doc(task.id).update({
      'taskName': task.taskName,
      'assignedTo': task.assignedTo,
      'title': task.title,
      'isDone': task.isDone,
    });
  }

  Future<void> deleteTask(String username, String taskId) async {
    await _tasksRef(username).doc(taskId).delete();
  }

  Future<void> toggleDone(String username, String taskId, bool isDone) async {
    await _tasksRef(username).doc(taskId).update({'isDone': isDone});
  }
}