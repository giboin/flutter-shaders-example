import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Playground<T extends List<(String, double)>> extends StatefulWidget {
  const Playground({
    super.key,
    required this.builder,
    required this.valuesToPlayWith,
  });

  final Widget Function(BuildContext context, T valuesToPlayWith) builder;
  final T valuesToPlayWith;

  @override
  State<Playground<T>> createState() => _PlaygroundState<T>();
}

class _PlaygroundState<T extends List<(String, double)>>
    extends State<Playground<T>> {
  List<(String, double)> _vars = [];

  @override
  void initState() {
    super.initState();
    _vars = widget.valuesToPlayWith;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: widget.builder(context, _vars as T))),
        ..._vars.mapIndexed((index, value) => SizedBox(
              height: 50,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text('${value.$1}: ${value.$2.toStringAsFixed(2)}'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      value: _vars.elementAtOrNull(index)?.$2 ?? 0.0,
                      onChanged: (newValue) {
                        setState(() {
                          _vars[index] = (value.$1, newValue);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            )),
      ],
    );
  }
}

extension PlaygroundExtension on List<(String, double)> {
  double get(String key) {
    return firstWhereOrNull((e) => e.$1 == key)?.$2 ?? 0.0;
  }
}
