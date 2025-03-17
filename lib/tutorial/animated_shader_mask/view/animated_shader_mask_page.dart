import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// What about animated shaders?
/// Remember that we can pass any value from dart to the shader.
///
/// This example is the same as the previous one, but one of the values
/// passed to the shader is animated.
///
/// To force the shader to repaint, we add an `AnimatedBuilder` that listens
/// to an `AnimationController`.
class AnimatedShaderMaskPage extends StatefulWidget {
  const AnimatedShaderMaskPage({super.key});

  @override
  State<AnimatedShaderMaskPage> createState() => _AnimatedShaderMaskPageState();
}

class _AnimatedShaderMaskPageState extends State<AnimatedShaderMaskPage>
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => ShaderBuilder(
                (context, shader, child) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
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
              child: const Center(
                child: Text(
                  'hello world',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                _controller.forward(from: 0);
              },
              child: const Text('launch'),
            ),
          ],
        ),
      ),
    );
  }
}
