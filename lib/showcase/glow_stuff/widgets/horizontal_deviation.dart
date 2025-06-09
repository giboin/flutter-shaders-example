import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/gyro_builder.dart';

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
      return 0.5;
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
            deviationX: _position,
            builder: (context, value) {
              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 350),
                tween: Tween<double>(begin: 0, end: value),
                builder: (context, animationValue, child) {
                  return _HorzDevInherit(
                    position: animationValue,
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

class GyroRoll extends StatelessWidget {
  const GyroRoll({
    super.key,
    required this.deviationX,
    required this.builder,
  });

  final double deviationX;

  final Widget Function(BuildContext context, double deviation) builder;

  @override
  Widget build(BuildContext context) {
    return GyroBuilder(builder: (context, rotationX, rotationY) {
      final amount = defaultTargetPlatform == TargetPlatform.android
          ? rotationY
          : rotationX;
      final factor = defaultTargetPlatform == TargetPlatform.iOS ? 1500 : 750;

      return builder(
        context,
        deviationX + (amount * 100).toInt() / factor,
      );
    });
  }
}
