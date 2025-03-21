import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// Now we know how to give an image to a shader, but what if we want
/// to apply the previous ripple effect to a Widget? How could we
/// convert the widget's rendering to a ui.Image?
///
/// The answer is `AnimatedSampler`. This widget takes a child, and gives
/// you a callback in which you can access the image of the child
/// rendered in a canvas.
///
/// Here is an example on how to use it to apply the ripple effect on a page.
class RipplePage extends StatefulWidget {
  const RipplePage({super.key});

  @override
  State<RipplePage> createState() => _RipplePageState();
}

class _RipplePageState extends State<RipplePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  Offset? _tapPosition;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => ShaderBuilder(
          // Warning : AnimatedSampler does not work with Platform views
          (context, shader, child) => AnimatedSampler(
            (image, size, canvas) {
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
            child: child ?? const SizedBox.shrink(),
          ),
          assetKey: 'shaders/ripple.frag',
          child: child,
        ),
        child: _MyPage(
          launchRipple: () => setState(() {
            _tapPosition = Offset(
              screenSize.width / 2,
              screenSize.height - 100,
            );
            _controller.forward(from: 0);
          }),
        ),
      ),
    );
  }
}

class _MyPage extends StatelessWidget {
  const _MyPage({required this.launchRipple});

  final VoidCallback launchRipple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchRipple();
        },
        child: const Icon(Icons.water_drop),
      ),
      body: Column(
        children: [
          const Text(
            'Ripple Effect',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This is an example for an interactive page that you can animate with shaders.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const Text(
            'Click on the floating button to see the ripple effect.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'hello world',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
