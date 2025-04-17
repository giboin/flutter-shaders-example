import 'package:flutter/material.dart';

class TodoItem {
  const TodoItem({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
  });

  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  final String category;
}

enum Priority {
  low,
  medium,
  high;

  Color get color {
    return switch (this) {
      Priority.low => Colors.green,
      Priority.medium => Colors.orange,
      Priority.high => Colors.red,
    };
  }
}
