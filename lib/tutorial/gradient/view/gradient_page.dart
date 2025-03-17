import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// The most basic way of using shaders in Flutter.
/// This example shows how to create a gradient using a fragment shader.
///
/// The shader is initialized in the bootstrap method of the app and
/// passed down to the page that needs it.
///
/// Then the shader is used in a custom painter to paint the gradient.
class GradientPage extends StatelessWidget {
  const GradientPage({super.key, required this.shader});

  final FragmentShader shader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: MyPainter(shader: shader, color: Colors.green),
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

/// In the paint method of the custom painter,
/// we can pass some values to the variables defined in the .frag shader file.
///
/// In this case (shaders/gradient.frag), the shader file expects those vectors:
/// ```
/// uniform vec2 uSize;
/// uniform vec4 uColor;
/// ```
/// So we pass:
/// - the size's first value (width) to the first float (0)
/// - the size's second value (height) to the second float (1),
/// - the color's red value to the third float (2),
/// - the color's green value to the fourth float (3),
/// - the color's blue value to the fifth float (4),
/// - then the color's alpha value to the sixth float (5).
///
/// In glsl, the color is defined as a vector with four values (r, g, b, a)
/// that go from 0 to 1. So we divide the color's values by 255 to get the
/// normalized values.
class MyPainter extends CustomPainter {
  const MyPainter({required this.shader, required this.color});

  final FragmentShader shader;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, color.r.toDouble())
      ..setFloat(3, color.g.toDouble())
      ..setFloat(4, color.b.toDouble())
      ..setFloat(5, color.a.toDouble());

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) {
    return oldDelegate.shader != shader || oldDelegate.color != color;
  }
}
