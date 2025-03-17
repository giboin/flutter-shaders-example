import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HorizontalDeviationProvider extends StatefulWidget {
  const HorizontalDeviationProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HorizontalDeviationProvider> createState() =>
      _HorizontalDeviationProviderState();

  static double of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_HorzDevInherit>();
    if (result == null) {
      throw Exception('No _HorzDevInherit found in context');
    }

    return result.position;
  }
}

class _HorizontalDeviationProviderState
    extends State<HorizontalDeviationProvider> {
  Size _biggest = const Size(1, 1);

  double _position = 0.5;

  void _handlePointerHover(PointerHoverEvent event) {
    final frac = (event.localPosition.dx / _biggest.width) * 2 - 1;
    final sign = frac.sign;
    final quad = frac * frac * sign;

    setState(() {
      _position = (quad + 1) / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrainst) {
        _biggest = constrainst.biggest;

        return Listener(
          onPointerHover: _handlePointerHover,
          child: GyroRoll(
            rotationX: _position,
            builder: (context, gyroValue) {
              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 350),
                tween: Tween<double>(begin: 0, end: gyroValue),
                builder: (context, tweenValue, child) {
                  return _HorzDevInherit(
                    position: tweenValue,
                    child: widget.child,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _HorzDevInherit extends InheritedWidget {
  const _HorzDevInherit({
    required super.child,
    required this.position,
  });

  final double position;

  @override
  bool updateShouldNotify(_HorzDevInherit old) {
    return true;
  }
}

class GyroRoll extends StatefulWidget {
  const GyroRoll({
    super.key,
    required this.rotationX,
    required this.builder,
  });

  final double rotationX;

  final Widget Function(BuildContext context, double deviation) builder;

  @override
  State<GyroRoll> createState() => _GyroRollState();
}

class _GyroRollState extends State<GyroRoll> {
  late double _rotationX = widget.rotationX;
  bool _renderLock = false;
  StreamSubscription<GyroscopeEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        _subscription = gyroscopeEventStream().listen(_handleGyro);
        break;
      default:
        break;
    }
  }

  @override
  void didUpdateWidget(covariant GyroRoll oldWidget) {
    super.didUpdateWidget(oldWidget);

    _rotationX = widget.rotationX;

    _renderLock = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      _renderLock = false;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleGyro(GyroscopeEvent event) {
    if (_renderLock) return;
    _renderLock = true;

    final amount =
        defaultTargetPlatform == TargetPlatform.iOS ? event.x : event.y;
    final factor = defaultTargetPlatform == TargetPlatform.iOS ? 1500 : 750;

    setState(() {
      _rotationX += (amount * 100).toInt() / factor;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _renderLock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _rotationX);
  }
}
