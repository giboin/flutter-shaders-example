import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class HaloPage extends StatefulWidget {
  const HaloPage({super.key});

  @override
  State<HaloPage> createState() => _HaloPageState();
}

class _HaloPageState extends State<HaloPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(hours: 1),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => ShaderBuilder(
            (context, shader, child) {
              return CustomPaint(
                painter: HaloPainter(
                  shader: shader,
                  time: _controller.value * 5000,
                ),
                child: child,
              );
            },
            assetKey: 'shaders/halo.frag',
          ),
        ),
      ),
    );
  }
}

class HaloPainter extends CustomPainter {
  HaloPainter({
    required this.shader,
    required this.time,
  });
  final FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, time)
      ..setFloat(1, size.width)
      ..setFloat(2, size.height);

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    final rect = Offset.zero & size;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
