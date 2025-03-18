import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_shaders_example/showcase/page_curl/model/todo_item.dart';

class TodoTile extends StatefulWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onDelete,
  });

  final TodoItem todo;
  final VoidCallback onDelete;

  @override
  State<TodoTile> createState() => _TodoTileState();
}

const curlMargin = 15.0;

class _TodoTileState extends State<TodoTile>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  double _dragOrigin = 0.0;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      if (_dragOffset < -200.0) {
        widget.onDelete();
        _dragOffset = 0.0;
      } else {
        _dragOffset = 0.0;
      }
    });
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _dragOrigin = details.localPosition.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(curlMargin),
              child: _DeleteBackground(),
            ),
          ),
          ShaderBuilder(
            (context, shader, tileWidget) {
              return AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setFloat(0, size.width)
                    ..setFloat(1, size.height)
                    ..setFloat(
                      2,
                      _dragOffset *
                          ((size.width - _dragOrigin) * 2 / size.width + 1),
                    )
                    ..setFloat(3, 0)
                    ..setFloat(4, curlMargin)
                    ..setFloat(5, curlMargin)
                    ..setFloat(6, size.width - curlMargin)
                    ..setFloat(7, size.height - curlMargin)
                    ..setFloat(8, 8.0)
                    ..setImageSampler(0, image);
                  canvas.drawRect(
                    Offset.zero & size,
                    Paint()..shader = shader,
                  );
                },
                child: tileWidget ?? SizedBox.shrink(),
              );
            },
            assetKey: 'shaders/page_curl.frag',
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(curlMargin),
                child: _StaticTile(todo: widget.todo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaticTile extends StatelessWidget {
  const _StaticTile({
    required this.todo,
  });

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: todo.priority.color.withAlpha(20),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      todo.category,
                      style: TextStyle(
                        color: todo.priority.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      'Due ${_formatDate(todo.dueDate)}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              todo.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              todo.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours == 1) {
      return '1 hour';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 32.0),
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
