import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  // Get all todos as a stream (real-time updates)
  Stream<List<Todo>> getTodos() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add a new todo
  Future<void> addTodo(String title) async {
    await _firestore.collection(_collection).add({
      'title': title,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Toggle todo completion status
  Future<void> toggleTodo(String id, bool completed) async {
    await _firestore.collection(_collection).doc(id).update({
      'completed': completed,
    });
  }

  // Update todo title
  Future<void> updateTodo(String id, String title) async {
    await _firestore.collection(_collection).doc(id).update({
      'title': title,
    });
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
