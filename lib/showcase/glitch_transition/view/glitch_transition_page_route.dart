import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GlitchTransitionPageRoute extends PageRoute {
  GlitchTransitionPageRoute({
    super.settings,
    super.requestFocus,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    bool barrierDismissible = false,
    required this.child,
  });

  final Widget child;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => "glitch transition barrier";

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderBuilder(
          (context, shader, child) {
            return AnimatedSampler(
              (image, size, canvas) {
                final time = 2 - animation.value * 2;
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, time)
                  ..setImageSampler(0, image);

                canvas.drawRect(
                  Offset.zero & size,
                  Paint()..shader = shader,
                );
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
          assetKey: 'shaders/glitch.frag',
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
