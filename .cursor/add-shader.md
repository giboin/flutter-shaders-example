# Project and task overview

This Flutter app contains a collection of shader demonstrations.
It is organized into two main sections:

1. A tutorial section explaining how to use shaders in Flutter
2. A showcase section featuring various shader implementations

You are provided with a new shader file from the `shaders` folder that needs to be integrated into the Flutter app. If you cannot locate this file, please ask the user for assistance.

Your task is to integrate the new shader into the showcase section by following these steps:

1. Create a new directory in the `lib/showcase` folder, named after the shader
2. Add a new file named `view/[shader name]_page.dart` in the new directory
3. Create any additional required files in the new directory
4. Add a new entry to the showcase section in `lib/app/view/home.dart`

# Implementation Rules

- The file with the `_page.dart` suffix is the one that should be imported in `home.dart`
- Pass all input uniforms to the shader from the Dart code
- For time-based uniforms, use an animation controller and follow the animation rules below
- For texture-based uniforms, use the `AnimatedSampler` widget's image parameter: `shader.setImageSampler(0, image)`. If you see a `uniform sampler2D` in the shader code, you have to use `AnimatedSampler`.
- Create all widgets in separate files
- Use `StatelessWidget` whenever possible
- Use `ShaderMask` widget for applying shaders to a widget's rendering
- Use `CustomPaint` implementation for canvas-based shader applications
- The page should effectively demonstrate the shader's capabilities in a clear and concise manner
- Prefer using an `OutlinedButton` over a `GestureDetector`
- Use the fewer widgets possible.
- Instead of using `Container`, prefer using more specific widgets like `ColoredBox`, `DecoratedBox`, `Padding`, etc.

## Animation Guidelines

When using an animation controller for shader animation, follow these rules:

- Initialize the animation controller in the `initState` method
- Use a state class with `SingleTickerProviderStateMixin` mixin, passing `this` as the `vsync` parameter
- Dispose of the animation controller in the `dispose` method
- Use the animation controller's value in the `builder` method of the `AnimatedBuilder` widget

# Examples:

### Example 1: CustomPaint implementation

Used for canvas-based shader applications. Here, the shader is applied to the background of the page.

```dart
class ShaderBuilderPage extends StatelessWidget {
  const ShaderBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShaderBuilder(
        (context, shader, child) {
          return CustomPaint(
            painter: GradientPainter(shader: shader, color: Colors.blue),
            child: child,
          );
        },
        assetKey: 'shaders/gradient.frag',
        child: const Center(
          child: Text(
            'hello world',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
        ),
      ),
    );
  }
}


class GradientPainter extends CustomPainter {
  const GradientPainter({required this.shader, required this.color});

  final FragmentShader shader;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, color.r.toDouble())
      ..setFloat(3, color.g.toDouble())
      ..setFloat(4, color.b.toDouble())
      ..setFloat(5, color.a.toDouble());

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) {
    return oldDelegate.shader != shader || oldDelegate.color != color;
  }
}

```

### Example 2: ShaderMask implementation

Used for applying shaders to specific widgets. Here, the shader is applied to a `Text` widget.

```dart
class ShaderMaskPage extends StatelessWidget {
  const ShaderMaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShaderBuilder(
        (context, shader, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              const color = Colors.blue;

              shader
                ..setFloat(0, bounds.width)
                ..setFloat(1, bounds.height)
                ..setFloat(2, color.r.toDouble())
                ..setFloat(3, color.g.toDouble())
                ..setFloat(4, color.b.toDouble())
                ..setFloat(5, color.a.toDouble());

              return shader;
            },
            child: child,
          );
        },
        assetKey: 'shaders/gradient.frag',
        child: const Center(
          child: Text(
            'hello world',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
```

### Example 3: AnimatedBuilder, AnimatedSampler implementation

A more complex example that uses both `AnimatedBuilder` and `AnimatedSampler` widgets.

```dart
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

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => ShaderBuilder(
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
          child: ColoredBox(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'hello world',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    child: const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('ripple', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _tapPosition = Offset(
                          screenSize.width / 2,
                          screenSize.height - 100,
                        );
                        _controller.forward(from: 0);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
