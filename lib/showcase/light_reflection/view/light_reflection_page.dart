import 'package:flutter/material.dart';
import 'widgets/reflection_credit_card.dart';

class LightReflectionPage extends StatelessWidget {
  const LightReflectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ReflectionCreditCard(),
      ),
    );
  }
}
