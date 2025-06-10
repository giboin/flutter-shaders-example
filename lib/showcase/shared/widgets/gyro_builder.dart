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

class _GyroBuilderState extends State<GyroBuilder> {
  StreamSubscription<GyroscopeEvent>? _subscription;
  double _rotationX = 0;
  double _rotationY = 0;
  bool _verticalSlider = false;
  bool _renderLock = false;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _handleGyro(GyroscopeEvent event) {
    if (_renderLock) return;
    _renderLock = true;
    setState(() {
      if (defaultTargetPlatform == TargetPlatform.android) {
        _rotationX += event.y;
        _rotationY += event.x;
      } else {
        _rotationX += event.x;
        _rotationY += event.y;
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
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
                Center(child: widget.builder(context, _rotationX, _rotationY)),
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
                    value: _verticalSlider ? _rotationY : _rotationX,
                    min: -1,
                    max: 1,
                    onChanged: (value) {
                      setState(() {
                        _verticalSlider
                            ? _rotationY = value
                            : _rotationX = value;
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

    return widget.builder(context, _rotationX, _rotationY);
  }
}
