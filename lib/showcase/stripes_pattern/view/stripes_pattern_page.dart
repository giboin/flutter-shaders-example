import 'package:flutter/material.dart';
import 'package:flutter_shaders_example/showcase/stripes_pattern/view/striped.dart';

class StripesPatternPage extends StatelessWidget {
  const StripesPatternPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Striped(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                color1: Colors.orange,
                color2: Colors.red,
              ),
            ),
            Text(
              'Hello',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
