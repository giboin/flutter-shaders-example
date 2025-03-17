import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// Nothing new here, just an other example of using
/// `ShaderMask` with an animation, to show that it works on any widget.
/// Even a whole screen or an app.
class AnimatedShaderMaskOnScreenPage extends StatefulWidget {
  const AnimatedShaderMaskOnScreenPage({super.key});

  @override
  State<AnimatedShaderMaskOnScreenPage> createState() =>
      _AnimatedShaderMaskOnScreenPageState();
}

class _AnimatedShaderMaskOnScreenPageState
    extends State<AnimatedShaderMaskOnScreenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => ShaderBuilder(
            (context, shader, child) {
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) {
                  const color = Colors.blue;

                  shader
                    ..setFloat(0, bounds.width * _controller.value)
                    ..setFloat(1, bounds.height)
                    ..setFloat(2, color.r.toDouble() / 255)
                    ..setFloat(3, color.g.toDouble() / 255)
                    ..setFloat(4, color.b.toDouble() / 255)
                    ..setFloat(5, color.a.toDouble() / 255);

                  return shader;
                },
                child: child,
              );
            },
            assetKey: 'shaders/gradient.frag',
            child: child,
          ),
          child: _Screen(controller: _controller),
        ),
      ),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white24,
      child: Center(
        child: MaterialButton(
          onPressed: () {
            controller.forward(from: 0);
          },
          child: const Text(
            'launch',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
