import 'dart:async';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

/// In-memory mock implementation of TodoService for integration testing.
class MockTodoService implements TodoService {
  final List<Todo> _todos = [];
  final StreamController<List<Todo>> _controller =
      StreamController<List<Todo>>.broadcast();
  int _idCounter = 0;

  void _emitTodos() {
    _controller.add(List.unmodifiable(_todos));
  }

  @override
  Stream<List<Todo>> getTodos() {
    // Create a stream that emits current state immediately, then listens for updates
    late StreamController<List<Todo>> controller;
    controller = StreamController<List<Todo>>(
      onListen: () {
        // Emit current state immediately when listener subscribes
        controller.add(List.unmodifiable(_todos));
        // Then forward all future updates
        _controller.stream.listen(
          (data) => controller.add(data),
          onError: (e) => controller.addError(e),
          onDone: () => controller.close(),
        );
      },
    );
    return controller.stream;
  }

  @override
  Future<void> addTodo(String title) async {
    _idCounter++;
    final todo = Todo(
      id: 'todo_$_idCounter',
      title: title,
      completed: false,
      createdAt: DateTime.now(),
    );
    _todos.insert(0, todo);
    _emitTodos();
  }

  @override
  Future<void> toggleTodo(String id, bool completed) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(completed: completed);
      _emitTodos();
    }
  }

  @override
  Future<void> updateTodo(String id, String title) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(title: title);
      _emitTodos();
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    _emitTodos();
  }

  void dispose() {
    _controller.close();
  }
}
