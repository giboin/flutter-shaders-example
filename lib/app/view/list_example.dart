import 'package:flutter/material.dart';

class ListExample extends StatelessWidget {
  const ListExample({super.key});

  Color _getRandomColor(int seed) {
    final random = (seed * 15485863) % 2147483647;

    final randomColor = Color.fromRGBO(
      (random % 256),
      ((random ~/ 256) % 256),
      ((random ~/ 65536) % 256),
      1,
    );

    return Color.lerp(randomColor, Colors.white, 0.7) ??
        randomColor.withAlpha(50);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _getRandomColor(index),
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Image.asset(
                    height: 200,
                    width: 400,
                    fit: BoxFit.cover,
                    'assets/sample$index.jpg',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
