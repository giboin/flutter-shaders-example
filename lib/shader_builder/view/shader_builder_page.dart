import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glow_stuff_with_flutter/gradient/view/gradient_page.dart';

class ShaderBuilderPage extends StatelessWidget {
  const ShaderBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShaderBuilder(
        (context, shader, child) {
          return CustomPaint(
            painter: MyPainter(shader: shader, color: Colors.blue),
            child: child,
          );
        },
        assetKey: 'shaders/gradient.frag',
        child: const Center(
          child: Text(
            'hello world',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
        ),
      ),
    );
  }
}
