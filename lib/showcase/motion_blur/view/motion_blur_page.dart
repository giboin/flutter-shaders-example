import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class MotionBlurPage extends StatefulWidget {
  const MotionBlurPage({super.key});

  @override
  State<MotionBlurPage> createState() => _MotionBlurPageState();
}

class _MotionBlurPageState extends State<MotionBlurPage>
    with SingleTickerProviderStateMixin {
  double? _lastKnownPosition;
  double? _lastScrollTime;
  double _velocity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motion Blur'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final now = DateTime.now().millisecondsSinceEpoch.toDouble();
          final currentPixels = scrollNotification.metrics.pixels;

          if (_lastKnownPosition != null && _lastScrollTime != null) {
            final delta = currentPixels - (_lastKnownPosition ?? 0);
            final timeDelta = now - (_lastScrollTime ?? 0);
            if (timeDelta > 0) {
              _velocity = delta / timeDelta * 1000; // pixels per second
            }
          }

          _lastKnownPosition = currentPixels;
          _lastScrollTime = now;

          return false;
        },
        child: ShaderBuilder(
          (context, shader, child) {
            return AnimatedSampler(
              (image, size, canvas) {
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, 0)
                  ..setFloat(3, _velocity / 100)
                  ..setImageSampler(0, image);
                canvas.drawRect(
                  Offset.zero & size,
                  Paint()..shader = shader,
                );
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
          assetKey: 'shaders/motion_blur.frag',
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'coucou Item $index',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
