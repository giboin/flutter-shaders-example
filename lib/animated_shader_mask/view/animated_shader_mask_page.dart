import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

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
    super.dispose();
    _controller.dispose();
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
                        ..setFloat(2, color.red.toDouble() / 255)
                        ..setFloat(3, color.green.toDouble() / 255)
                        ..setFloat(4, color.blue.toDouble() / 255)
                        ..setFloat(5, color.alpha.toDouble() / 255);
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
