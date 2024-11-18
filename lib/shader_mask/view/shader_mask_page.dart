import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// How can we apply a shader to a widget in Flutter?
/// The `ShaderMask` widget is the answer.
///
/// It allows you to apply a shader to a widget, using a `ShaderCallback`.
/// In the `ShaderCallback`, you can use the same logic as in the
/// `paint` method of a custom painter to pass values to the shader.
///
/// The shader will then be applied to the child of the `ShaderMask`.
class ShaderMaskPage extends StatelessWidget {
  const ShaderMaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShaderBuilder(
        (context, shader, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              const color = Colors.blue;

              shader
                ..setFloat(0, bounds.width)
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
    );
  }
}
