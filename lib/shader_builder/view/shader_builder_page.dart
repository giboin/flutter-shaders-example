import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glow_stuff_with_flutter/gradient/view/gradient_page.dart';

/// The most straightforward way of using shaders in Flutter.
/// This example shows how to use a .frag file with a `ShaderBuilder`.
///
/// `ShaderBuilder` is a widget from the `flutter_shaders` package.
/// It allows you to create a shader from a .frag file and pass it to a child
/// widget, without having to initialize the shader in the bootstrap method.
///
/// Then, we can use the shader in the same custom painter as before.
///
/// The output is the same as the previous example, but the shader is now
/// initialized in the page itself.
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
