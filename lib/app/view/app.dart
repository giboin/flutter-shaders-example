import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glow_stuff_with_flutter/app/view/home.dart';

class App extends StatelessWidget {
  const App({super.key, required this.shader});

  final FragmentShader shader;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      home: HomeView(
        shader: shader,
      ),
    );
  }
}
