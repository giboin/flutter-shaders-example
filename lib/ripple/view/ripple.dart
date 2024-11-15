import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class RipplePage extends StatefulWidget {
  const RipplePage({super.key});

  @override
  State<RipplePage> createState() => _RipplePageState();
}

class _RipplePageState extends State<RipplePage>
    with SingleTickerProviderStateMixin {
  double sliderValue = 0;
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
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadImage('assets/jamesweb.jpg'),
          builder: (context, snapshot) {
            final image = snapshot.data;
            if (image == null) {
              return const SizedBox.shrink();
            }
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => ShaderBuilder(
                (context, shader, child) => AnimatedSampler(
                  (image, size, offset, canvas) {
                    shader
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setFloat(2, _tapPosition?.dx ?? 200)
                      ..setFloat(3, _tapPosition?.dy ?? 200)
                      ..setFloat(4, _controller.value * 3)
                      ..setImageSampler(0, image);
                    canvas.drawRect(
                      Offset.zero & size,
                      Paint()..shader = shader,
                    );
                  },
                  child: child!,
                ),
                assetKey: 'shaders/ripple.frag',
                child: child,
              ),
              child: ColoredBox(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'hello world',
                        style: TextStyle(
                          fontWeight: ui.FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child:
                                Text('ripple', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _tapPosition = Offset(
                              screenSize.width / 2,
                              screenSize.height - 100,
                            );
                            _controller.forward(from: 0);
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Slider(
                        activeColor: Colors.purple,
                        inactiveColor: Colors.blue,
                        value: sliderValue,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                          });
                        },
                      ),
                    ],
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
