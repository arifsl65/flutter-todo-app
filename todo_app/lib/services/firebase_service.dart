import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';
import 'todo_service.dart';

class FirebaseService implements TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  @override
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

  @override
  Future<void> addTodo(String title) async {
    await _firestore.collection(_collection).add({
      'title': title,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> toggleTodo(String id, bool completed) async {
    await _firestore.collection(_collection).doc(id).update({
      'completed': completed,
    });
  }

  @override
  Future<void> updateTodo(String id, String title) async {
    await _firestore.collection(_collection).doc(id).update({
      'title': title,
    });
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
