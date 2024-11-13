import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:glow_stuff_with_flutter/animated_shader_mask/view/animated_shader_mask_page.dart';
import 'package:glow_stuff_with_flutter/animated_shader_mask_on_screen/view/animated_shader_mask_on_screen_page.dart';
import 'package:glow_stuff_with_flutter/glow_stuff/view/glow_stuff_page.dart';
import 'package:glow_stuff_with_flutter/gradient/view/gradient_page.dart';
import 'package:glow_stuff_with_flutter/ripple/view/ripple.dart';
import 'package:glow_stuff_with_flutter/shader_builder/view/shader_builder_page.dart';
import 'package:glow_stuff_with_flutter/shader_mask/view/shader_mask_page.dart';
import 'package:glow_stuff_with_flutter/water_ripple/view/water_ripple_page.dart';

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
                    title: const Text('shader builder page'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<ShaderBuilderPage>(
                        builder: (context) => const ShaderBuilderPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('shader mask page'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<ShaderMaskPage>(
                        builder: (context) => const ShaderMaskPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('animated shader mask'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<AnimatedShaderMaskPage>(
                        builder: (context) => const AnimatedShaderMaskPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('animated shader mask on screen'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<AnimatedShaderMaskOnScreenPage>(
                        builder: (context) =>
                            const AnimatedShaderMaskOnScreenPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('water ripple'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<WaterRipplePage>(
                        builder: (context) => const WaterRipplePage(),
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
