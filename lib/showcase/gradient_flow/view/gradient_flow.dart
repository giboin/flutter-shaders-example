import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GradientFlowPage extends StatefulWidget {
  const GradientFlowPage({super.key});

  @override
  State<GradientFlowPage> createState() => _GradientFlowPageState();
}

class _GradientFlowPageState extends State<GradientFlowPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _time = elapsed.inMilliseconds / 100.0;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShaderBuilder(
        (context, shader, child) {
          return CustomPaint(
            painter: GradientFlowPainter(
              shader: shader,
              time: _time,
            ),
            size: MediaQuery.sizeOf(context),
          );
        },
        assetKey: 'shaders/gradient_flow.frag',
      ),
    );
  }
}

class GradientFlowPainter extends CustomPainter {
  const GradientFlowPainter({
    required this.shader,
    required this.time,
  });
  final FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    const colorPrimary = Colors.red;
    const colorSecondary = Colors.orange;
    const colorAccent1 = Colors.redAccent;
    const colorAccent2 = Colors.orangeAccent;

    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, colorPrimary.r / 255)
      ..setFloat(4, colorPrimary.g / 255)
      ..setFloat(5, colorPrimary.b / 255)
      ..setFloat(6, colorSecondary.r / 255)
      ..setFloat(7, colorSecondary.g / 255)
      ..setFloat(8, colorSecondary.b / 255)
      ..setFloat(9, colorAccent1.r / 255)
      ..setFloat(10, colorAccent1.g / 255)
      ..setFloat(11, colorAccent1.b / 255)
      ..setFloat(12, colorAccent2.r / 255)
      ..setFloat(13, colorAccent2.g / 255)
      ..setFloat(14, colorAccent2.b / 255);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
