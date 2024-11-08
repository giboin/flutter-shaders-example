import 'package:flutter/material.dart';
import 'package:glow_stuff_with_flutter/glow_stuff/view/glow_stuff_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      home: const GlowStuffPage(),
    );
  }
}
