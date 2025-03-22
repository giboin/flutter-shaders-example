import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// Controls if you want to trigger a glitch transition to this page or from this page.
/// We could have added a third type primaryAndSecondary if we wanted to trigger a
/// glitch transition from the page AND to the page.
enum GlitchTransitionType {
  /// will trigger a glitch transition to this page.
  primary,

  /// will trigger a glitch transition from this page.
  secondary,
}

/// A page route that uses a glitch transition.
///
/// The glitch transition is a custom shader that creates a glitch effect on the
/// page.
///
/// The transition from an other type of page to glitch transition page is not handled in this example
class GlitchTransitionPageRoute<T extends Widget> extends PageRoute<T> {
  GlitchTransitionPageRoute({
    super.settings,
    super.requestFocus,
    required this.child,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    bool barrierDismissible = false,
    required this.type,
  });

  final T child;

  final GlitchTransitionType type;

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
      animation: switch (type) {
        GlitchTransitionType.primary => animation,
        GlitchTransitionType.secondary => secondaryAnimation,
      },
      builder: (context, child) {
        // Keeps the previous page visible for half of the transition
        if (type == GlitchTransitionType.primary && animation.value < 0.5) {
          return SizedBox.shrink();
        }

        return ShaderBuilder(
          (context, shader, child) {
            return AnimatedSampler(
              (image, size, canvas) {
                final time = switch (type) {
                  // The new page is visible for the second half of the transition,
                  // and we want the `time` passed to the shader to be 1 when it appears
                  // and 0 when the transition is complete.
                  GlitchTransitionType.primary =>
                    1 - (max(animation.value, 0.5) - 0.5) * 2,

                  // The previous page is visible for the first half of the transition,
                  // and we want the `time` passed to the shader to be 0 at the beggining of the transition
                  // and 1 when the previous page dissapears.
                  GlitchTransitionType.secondary =>
                    (min(secondaryAnimation.value, 0.5)) * 2,
                };

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
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}
