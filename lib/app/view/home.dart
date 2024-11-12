import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glow_stuff_with_flutter/glow_stuff/view/glow_stuff_page.dart';
import 'package:glow_stuff_with_flutter/green_page/view/green_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.shader});

  final FragmentShader shader;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
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
    final safePadding = MediaQuery.paddingOf(context);

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      safePadding + const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          title: const Text('glow stuff'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<GlowStuffPage>(
                              builder: (context) => const GlowStuffPage(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          title: const Text('green page'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<GreenPage>(
                              builder: (context) => GreenPage(
                                shader: widget.shader,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: GestureDetector(
                          onTapDown: _handleTap,
                          child: const ListTile(
                            title: Text('ripple effect'),
                          ),
                        ),
                      ),
                    ],
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
      ),
    );
  }
}
