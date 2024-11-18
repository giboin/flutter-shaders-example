import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// Some shaders not only take vectors or floats as entry, but also textures.
/// In the .frag file, it is declared this way:
/// ```
/// uniform sampler2D texture;
/// ```
///
/// The dart object that we can pass to a shader as texture is a `ui.Image`.
/// We can pass an image to a shader by calling `setImageSampler` on the shader.
///
/// So if we call `shader.setImageSampler(0, image)` in dart, we can access
/// the image in the shader file by using the `texture` uniform.
///
/// This example is the same as the previous one,
/// except that this shader takes an image as input.
class WaterRipplePage extends StatefulWidget {
  const WaterRipplePage({super.key});

  @override
  State<WaterRipplePage> createState() => _WaterRipplePageState();
}

class _WaterRipplePageState extends State<WaterRipplePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  Offset? _tapPosition;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadImage('assets/jamesweb.jpg'),
          builder: (context, snapshot) {
            final image = snapshot.data;
            if (image == null) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              width: 300,
              height: 300,
              child: GestureDetector(
                onTapDown: (details) => setState(() {
                  _tapPosition = details.localPosition;
                  _controller.forward(from: 0);
                }),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => ShaderBuilder(
                    (context, shader, child) {
                      return CustomPaint(
                        painter: RipplePainter(
                          shader: shader,
                          offset: _tapPosition,
                          time: _controller.value * 3,
                          image: image,
                        ),
                        child: child,
                      );
                    },
                    assetKey: 'shaders/water_ripple.frag',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<ui.Image> loadImage(String assetPath) async {
  final buffer = await ImmutableBuffer.fromAsset(assetPath);
  final codec = await ui.instantiateImageCodecFromBuffer(buffer);
  final frame = await codec.getNextFrame();
  return frame.image;
}

class RipplePainter extends CustomPainter {
  RipplePainter({
    required this.shader,
    this.offset,
    required this.time,
    required this.image,
  });

  final FragmentShader shader;
  final Offset? offset;
  final double time;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, offset?.dx ?? 200)
      ..setFloat(3, offset?.dy ?? 200)
      ..setFloat(4, time)
      ..setImageSampler(0, image);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.shader != shader ||
        oldDelegate.time != time ||
        oldDelegate.offset != offset;
  }
}
