class Todo {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // From Firebase document
  factory Todo.fromMap(Map<String, dynamic> map, String id) {
    return Todo(
      id: id,
      title: map['title'] ?? '',
      completed: map['completed'] ?? false,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  // To Firebase document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
      'createdAt': createdAt,
    };
  }

  // From Go backend JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // To Go backend JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
