import 'package:flutter/material.dart';
import 'package:flutter_shaders_example/showcase/glow_stuff/widgets/apply_glow.dart';
import 'package:flutter_shaders_example/showcase/glow_stuff/widgets/examples.dart';
import 'package:flutter_shaders_example/showcase/glow_stuff/widgets/horizontal_deviation.dart';

class GlowStuffPage extends StatelessWidget {
  const GlowStuffPage({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const GlowStuffPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: GlowStuffView());
  }
}

class GlowStuffView extends StatelessWidget {
  const GlowStuffView({super.key});

  @override
  Widget build(BuildContext context) {
    return HorizontalDeviationProvider(
      child: ColoredBox(
        color: const Color(0xFF000000),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Container(height: 250)),
            const SliverToBoxAdapter(
              child: ApplyGlow(density: 0.9, child: TextEditableExample()),
            ),
            const SliverToBoxAdapter(
              child: ApplyGlow(
                density: 0.4,
                weight: 0.2,
                child: LongTextExample(),
              ),
            ),
            const SliverToBoxAdapter(
              child: ApplyGlow(
                density: 0.9,
                weight: 0.2,
                child: ImageExample(),
              ),
            ),
            const SliverToBoxAdapter(
              child: ApplyGlow(density: 0.9999, child: RiveExample()),
            ),
          ],
        ),
      ),
    );
  }
}
