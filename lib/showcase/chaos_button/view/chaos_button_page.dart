import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const int chaosDurationSeconds = 100;
const chaosDuration = Duration(seconds: chaosDurationSeconds);

class ChaosButtonPage extends StatefulWidget {
  const ChaosButtonPage({super.key});

  @override
  State<ChaosButtonPage> createState() => _ChaosButtonPageState();
}

class _ChaosButtonPageState extends State<ChaosButtonPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _chaos = false;
  double _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: chaosDuration,
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => ShaderBuilder(
            (context, shader, child) {
              return Stack(
                children: [
                  if (_chaos)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ChaosPainter(
                          shader: shader,
                          time: _controller.value * 400,
                          tapValue: _tapCount.toDouble(),
                        ),
                      ),
                    ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _chaos = !_chaos;
                        if (_chaos) {
                          _tapCount += 0.1;
                          _controller.forward();
                          _controller.repeat(reverse: true);
                        } else {
                          _controller.stop();
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 40,
                      ),
                    ),
                    child: const Text(
                      'Chaos Button',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            },
            assetKey: 'shaders/chaos_button.frag',
            child: child,
          ),
        ),
      ),
    );
  }
}

class ChaosPainter extends CustomPainter {
  const ChaosPainter({
    required this.shader,
    required this.time,
    required this.tapValue,
  });

  final FragmentShader shader;
  final double time;
  final double tapValue;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height * 2)
      ..setFloat(2, time)
      ..setFloat(3, tapValue);

    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(50),
      ),
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ChaosPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.tapValue != tapValue;
  }
}
