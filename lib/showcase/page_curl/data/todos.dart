import 'package:flutter_shaders_example/showcase/page_curl/model/todo_item.dart';

final List<TodoItem> todos = [
  TodoItem(
    title: 'Choose a Recipe',
    description: 'Browse through my master chef cookbook',
    dueDate: DateTime.now().add(const Duration(hours: 1)),
    priority: Priority.high,
    category: 'Cooking',
  ),
  TodoItem(
    title: 'Decide to Eat Pizza',
    description: 'Realize that cooking is too much work and pizza is life',
    dueDate: DateTime.now().add(const Duration(hours: 2)),
    priority: Priority.high,
    category: 'Decision Making',
  ),
  TodoItem(
    title: 'Order Pizza',
    description:
        'Call next door pizzeria and order the biggest pizza they have',
    dueDate: DateTime.now().add(const Duration(hours: 3)),
    priority: Priority.high,
    category: 'Food',
  ),
  TodoItem(
    title: 'Pretend to Cook',
    description:
        'Stand in the kitchen with an apron on, thinking really hard about pizza',
    dueDate: DateTime.now().add(const Duration(hours: 3)),
    priority: Priority.medium,
    category: 'Imagination',
  ),
  TodoItem(
    title: 'Receive and Devour Pizza',
    description: 'Open the door, grab the pizza, and eat it while '
        'thinking about the fact that it doesn\'t have to '
        'be made in my home to be homemade',
    dueDate: DateTime.now().add(const Duration(hours: 3)),
    priority: Priority.high,
    category: 'Feasting',
  ),
];
