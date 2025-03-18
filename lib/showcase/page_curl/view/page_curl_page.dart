import 'package:flutter/material.dart';
import 'package:flutter_shaders_example/showcase/page_curl/data/todos.dart';
import 'package:flutter_shaders_example/showcase/page_curl/model/todo_item.dart';
import 'package:flutter_shaders_example/showcase/page_curl/view/widgets/todo_tile.dart';

class PageCurlPage extends StatefulWidget {
  const PageCurlPage({super.key});

  @override
  State<PageCurlPage> createState() => _PageCurlPageState();
}

class _PageCurlPageState extends State<PageCurlPage>
    with SingleTickerProviderStateMixin {
  final List<TodoItem> _todos = todos;

  void _deleteTodo(int index) {
    final title = _todos.elementAtOrNull(index)?.title ?? 'number $index';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $title'),
        content: Text('Are you sure you want to delete $title?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Item ${title} deleted',
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 700,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              return TodoTile(
                todo: _todos[index],
                onDelete: () => _deleteTodo(index),
              );
            },
          ),
        ),
      ),
    );
  }
}
