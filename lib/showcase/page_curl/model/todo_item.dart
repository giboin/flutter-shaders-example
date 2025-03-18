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
    switch (this) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }
}
