// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

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

class MyPainter extends CustomPainter {
  MyPainter({required this.shader, required this.color});

  final FragmentShader shader;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, color.red.toDouble() / 255)
      ..setFloat(3, color.green.toDouble() / 255)
      ..setFloat(4, color.blue.toDouble() / 255)
      ..setFloat(5, color.alpha.toDouble() / 255);

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
