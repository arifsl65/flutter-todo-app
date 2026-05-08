import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class GoBackendService {
  // Change this to your Go backend URL
  // For Android emulator use: http://10.0.2.2:8080
  // For web/desktop use: http://localhost:8080
  final String baseUrl;

  GoBackendService({this.baseUrl = 'http://localhost:8080'});

  // Get all todos
  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Add a new todo
  Future<Todo> addTodo(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title}),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add todo');
    }
  }

  // Toggle todo completion
  Future<Todo> toggleTodo(String id, bool completed) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': completed}),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update todo');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
