import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_shaders_example/app/view/app_tile.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/first_demo_page.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/second_demo_page.dart';
import 'package:flutter_shaders_example/showcase/stripes_pattern/view/stripes_pattern_page.dart';
import 'package:flutter_shaders_example/tutorial/animated_shader_mask/view/animated_shader_mask_page.dart';
import 'package:flutter_shaders_example/tutorial/animated_shader_mask_on_screen/view/animated_shader_mask_on_screen_page.dart';
import 'package:flutter_shaders_example/showcase/glow_stuff/view/glow_stuff_page.dart';
import 'package:flutter_shaders_example/tutorial/gradient/view/gradient_page.dart';
import 'package:flutter_shaders_example/showcase/halo/view/halo.dart';
import 'package:flutter_shaders_example/tutorial/ripple/view/ripple.dart';
import 'package:flutter_shaders_example/tutorial/shader_builder/view/shader_builder_page.dart';
import 'package:flutter_shaders_example/tutorial/shader_mask/view/shader_mask_page.dart';
import 'package:flutter_shaders_example/tutorial/water_ripple/view/water_ripple_page.dart';
import 'package:flutter_shaders_example/showcase/chaos_button/view/chaos_button_page.dart';
import 'package:flutter_shaders_example/showcase/freeze/view/freeze_page.dart';
import 'package:flutter_shaders_example/showcase/page_curl/view/page_curl_page.dart';
import 'package:flutter_shaders_example/showcase/glitch_transition/view/glitch_transition_page_route.dart';
import 'package:flutter_shaders_example/showcase/motion_blur/view/motion_blur_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.shader});

  final FragmentShader shader;

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return Scaffold(
      body: Center(
        child: ListView(
          padding: safePadding + const EdgeInsets.all(24),
          children: [
            //
            // ------------------ Tutorial ------------------
            //
            const _SectionHeader(title: 'Tutorial'),
            const SizedBox(height: 20),
            AppTile(
              title: 'Gradient',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<GradientPage>(
                  builder: (context) => GradientPage(shader: shader),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Shader Builder',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<ShaderBuilderPage>(
                  builder: (context) => const ShaderBuilderPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Shader Mask',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<ShaderMaskPage>(
                  builder: (context) => const ShaderMaskPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Animated Shader Mask',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<AnimatedShaderMaskPage>(
                  builder: (context) => const AnimatedShaderMaskPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Animated Shader Mask On Screen',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<AnimatedShaderMaskOnScreenPage>(
                  builder: (context) => const AnimatedShaderMaskOnScreenPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Water Ripple',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<WaterRipplePage>(
                  builder: (context) => const WaterRipplePage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Ripple Effect',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<RipplePage>(
                  builder: (context) => const RipplePage(),
                ),
              ),
            ),
            const SizedBox(height: 48),
            //
            // ------------------ Showcase ------------------
            //
            const _SectionHeader(title: 'Showcase'),
            const SizedBox(height: 20),
            AppTile(
              title: 'Glow Stuff',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<GlowStuffPage>(
                  builder: (context) => const GlowStuffPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Stripes Pattern',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<StripesPatternPage>(
                  builder: (context) => const StripesPatternPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Halo',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<HaloPage>(
                  builder: (context) => const HaloPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Chaos Button',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<ChaosButtonPage>(
                  builder: (context) => const ChaosButtonPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Freeze Card',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<FreezePage>(
                  builder: (context) => const FreezePage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Page Curl',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<PageCurlPage>(
                  builder: (context) => const PageCurlPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Motion Blur',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<MotionBlurPage>(
                  builder: (context) => const MotionBlurPage(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTile(
              title: 'Glitch Transition',
              onTap: () => Navigator.of(context).push(
                GlitchTransitionPageRoute<FirstDemoPage>(
                  type: GlitchTransitionType.secondary,
                  child: FirstDemoPage(
                    buttonLabel: 'Go to second page',
                    buttonOnPressed: () => Navigator.of(context).push(
                      GlitchTransitionPageRoute<SecondDemoPage>(
                        type: GlitchTransitionType.primary,
                        child: const SecondDemoPage(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    );
  }
}
