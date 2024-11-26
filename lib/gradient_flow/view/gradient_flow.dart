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
      body: SizedBox.expand(
        child: ShaderBuilder(
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
      ),
    );
  }
}

class GradientFlowPainter extends CustomPainter {
  GradientFlowPainter({
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

    // Passer la résolution à l'uniforme
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      // Passer le temps à l'uniforme
      ..setFloat(2, time)
      // Passer les couleurs à l'uniforme (RGB values between 0 and 1)
      ..setFloat(3, colorPrimary.red / 255)
      ..setFloat(4, colorPrimary.green / 255)
      ..setFloat(5, colorPrimary.blue / 255)
      ..setFloat(6, colorSecondary.red / 255)
      ..setFloat(7, colorSecondary.green / 255)
      ..setFloat(8, colorSecondary.blue / 255)
      ..setFloat(9, colorAccent1.red / 255)
      ..setFloat(10, colorAccent1.green / 255)
      ..setFloat(11, colorAccent1.blue / 255)
      ..setFloat(12, colorAccent2.red / 255)
      ..setFloat(13, colorAccent2.green / 255)
      ..setFloat(14, colorAccent2.blue / 255);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
