import '../models/todo.dart';

/// Abstract interface for todo services.
/// Allows swapping implementations (Firebase, Go backend, mock) for testing.
abstract class TodoService {
  Stream<List<Todo>> getTodos();
  Future<void> addTodo(String title);
  Future<void> toggleTodo(String id, bool completed);
  Future<void> updateTodo(String id, String title);
  Future<void> deleteTodo(String id);
}
