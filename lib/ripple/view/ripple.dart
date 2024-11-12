import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class RipplePage extends StatefulWidget {
  const RipplePage({super.key});

  @override
  State<RipplePage> createState() => _RipplePageState();
}

class _RipplePageState extends State<RipplePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset? _tapPosition;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false;
            _tapPosition = null;
          });
          _controller.reset();
        }
      });
  }

  void _handleTap(TapDownDetails details) {
    if (_isAnimating) return;
    setState(() {
      _tapPosition = details.globalPosition;
      _isAnimating = true;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          body: Center(
            child: Card(
              child: GestureDetector(
                onTapDown: _handleTap,
                child: const ListTile(
                  title: Text('ripple effect'),
                ),
              ),
            ),
          ),
        ),
        if (_isAnimating && _tapPosition != null)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ShaderBuilder(
                  assetKey: 'shaders/ripple.frag',
                  (context, shader, child) {
                    shader
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setFloat(2, _tapPosition!.dx)
                      ..setFloat(3, _tapPosition!.dy)
                      ..setFloat(4, _controller.value)
                      ..setFloat(5, 0.5);

                    return ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => shader,
                      child: child,
                    );
                  },
                  child: Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
