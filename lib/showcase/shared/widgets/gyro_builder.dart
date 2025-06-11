import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroBuilder extends StatefulWidget {
  const GyroBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    double rotationX,
    double rotationY,
  ) builder;

  @override
  State<GyroBuilder> createState() => _GyroBuilderState();
}

class _GyroBuilderState extends State<GyroBuilder>
    with SingleTickerProviderStateMixin {
  StreamSubscription<GyroscopeEvent>? _subscription;
  Offset _offset = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _verticalSlider = false;
  bool _renderLock = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        _subscription = gyroscopeEventStream().listen(_handleGyro);
        break;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        break;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleGyro(GyroscopeEvent event) {
    final targetX = _offset.dx +
        (defaultTargetPlatform == TargetPlatform.android ? event.y : event.x);
    final targetY = _offset.dy +
        (defaultTargetPlatform == TargetPlatform.android ? event.x : event.y);

    if (_renderLock) return;
    _renderLock = true;

    _animation = Tween<Offset>(
      begin: _offset,
      end: Offset(targetX, targetY),
    ).animate(_controller);

    _controller.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 100), () {
      _offset = Offset(targetX, targetY);
      _renderLock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_subscription == null) {
      return Column(
        children: [
          Expanded(
            child:
                Center(child: widget.builder(context, _offset.dx, _offset.dy)),
          ),
          Text('${_verticalSlider ? 'Vertical' : 'Horizontal'} gyroscope mock'),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Switch(
                  value: _verticalSlider,
                  onChanged: (value) {
                    setState(() {
                      _verticalSlider = value;
                    });
                  },
                  inactiveTrackColor: Colors.blue,
                ),
                Expanded(
                  child: Slider(
                    value: _verticalSlider ? _offset.dy : _offset.dx,
                    min: -1,
                    max: 1,
                    onChanged: (value) {
                      final newOffset = _verticalSlider
                          ? Offset(_offset.dx, value)
                          : Offset(value, _offset.dy);

                      setState(() {
                        _offset = newOffset;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => widget.builder(
        context,
        _animation.value.dx,
        _animation.value.dy,
      ),
    );
  }
}
