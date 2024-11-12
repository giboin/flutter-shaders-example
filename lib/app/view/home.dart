import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glow_stuff_with_flutter/glow_stuff/view/glow_stuff_page.dart';
import 'package:glow_stuff_with_flutter/gradient/view/gradient_page.dart';
import 'package:glow_stuff_with_flutter/ripple/view/ripple.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.shader});

  final FragmentShader shader;

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: safePadding + const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('gradient page'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<GradientPage>(
                        builder: (context) => GradientPage(
                          shader: shader,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                    title: const Text('[wip] - ripple effect'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<RipplePage>(
                        builder: (context) => const RipplePage(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
