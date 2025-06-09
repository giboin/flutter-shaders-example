import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_shaders_example/showcase/glow_stuff/widgets/horizontal_deviation.dart';
import 'package:flutter_shaders_example/showcase/glow_stuff/widgets/scroll_aware_builder.dart';

class ApplyGlow extends StatefulWidget {
  const ApplyGlow({
    super.key,
    required this.child,
    this.density = 0.6,
    this.lightStrength = 1,
    this.weight = 0.09,
  });

  final Widget child;

  final double density;
  final double lightStrength;
  final double weight;

  @override
  State<ApplyGlow> createState() => _ApplyGlowState();
}

class _ApplyGlowState extends State<ApplyGlow> {
  ui.Image? _noise;

  late final _devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

  @override
  void initState() {
    super.initState();
    _getNoise();
  }

  @override
  void dispose() {
    _noise?.dispose();
    super.dispose();
  }

  Future<void> _getNoise() async {
    const assetImage = AssetImage('assets/noise.png');
    final key = await assetImage.obtainKey(ImageConfiguration.empty);

    assetImage
        .loadImage(
      key,
      PaintingBinding.instance.instantiateImageCodecWithSize,
    )
        .addListener(
      ImageStreamListener((image, synchronousCall) {
        setState(() {
          _noise = image.image;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noise = _noise;
    if (noise == null) {
      return const SizedBox.shrink();
    }

    final horzDev = HorizontalDeviationProvider.of(context);

    return ScrollAwareBuilder(
      builder: (context, scrollFraction) {
        return ShaderBuilder(
          assetKey: 'shaders/dir_glow.frag',
          child: widget.child,
          (context, shader, child) {
            return AnimatedSampler(
              child: child ?? const SizedBox.shrink(),
              (ui.Image image, Size size, Canvas canvas) {
                final devicePixelRatio = _devicePixelRatio;
                shader
                  ..setFloat(0, image.width.toDouble() / devicePixelRatio)
                  ..setFloat(1, image.height.toDouble() / devicePixelRatio)
                  ..setFloat(2, horzDev)
                  ..setFloat(3, scrollFraction)
                  ..setFloat(4, widget.density)
                  ..setFloat(5, widget.lightStrength)
                  ..setFloat(6, widget.weight)
                  ..setImageSampler(0, image)
                  ..setImageSampler(1, noise);
                canvas
                  ..save()
                  // ..translate(offset.dx, offset.dy)
                  ..drawRect(
                    Offset.zero & size,
                    Paint()..shader = shader,
                  )
                  ..restore();
              },
            );
          },
        );
      },
    );
  }
}
