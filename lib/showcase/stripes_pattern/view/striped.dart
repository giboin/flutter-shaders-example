import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class Striped extends StatefulWidget {
  const Striped({
    super.key,
    required this.child,
    required this.color1,
    required this.color2,
    this.tiles = 4.0,
    this.speed = 1.0,
    this.direction = 1.0,
    this.warpScale = 0.25,
    this.warpTiling = 0.5,
  });

  final Widget child;
  final double tiles;
  final double speed;
  final double direction;
  final double warpScale;
  final double warpTiling;
  final Color color1;
  final Color color2;

  @override
  State<Striped> createState() => _StripedState();
}

class _StripedState extends State<Striped> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    )
      ..forward()
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderBuilder(
          (context, shader, builderChild) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return shader
                  ..setFloat(0, bounds.width)
                  ..setFloat(1, bounds.height)
                  ..setFloat(2, 4.0)
                  ..setFloat(3, _controller.value * widget.speed)
                  ..setFloat(4, 1.0)
                  ..setFloat(5, 0.25)
                  ..setFloat(6, 0.5)
                  ..setFloat(7, widget.color1.r)
                  ..setFloat(8, widget.color1.g)
                  ..setFloat(9, widget.color1.b)
                  ..setFloat(10, widget.color2.r)
                  ..setFloat(11, widget.color2.g)
                  ..setFloat(12, widget.color2.b);
              },
              child: builderChild ?? SizedBox.shrink(),
            );
          },
          assetKey: 'shaders/stripes_pattern.frag',
          child: widget.child,
        );
      },
    );
  }
}
