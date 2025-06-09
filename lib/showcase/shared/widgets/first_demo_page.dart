import 'package:flutter/material.dart';

/// This is a demo page to showcase page transitions.

class FirstDemoPage extends StatelessWidget {
  const FirstDemoPage({
    super.key,
    required this.buttonLabel,
    required this.buttonOnPressed,
  });

  final String buttonLabel;
  final VoidCallback buttonOnPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: ColoredBox(
        color: Colors.blue.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demo Page',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: buttonOnPressed,
                child: Text(buttonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
