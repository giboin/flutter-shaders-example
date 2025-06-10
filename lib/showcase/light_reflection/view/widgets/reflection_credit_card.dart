import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/gyro_builder.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/playground.dart';

const _verticalFalloffFactorKey = 'verticalFalloffFactor';
const _rayRotationKey = 'rayRotation';
const _horizontalFalloffFactorKey = 'horizontalFalloffFactor';
const _rayIntensityKey = 'rayIntensity';
const _speedKey = 'speed';

class ReflectionCreditCard extends StatelessWidget {
  const ReflectionCreditCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Playground(
      valuesToPlayWith: [
        (_verticalFalloffFactorKey, 0.5),
        (_horizontalFalloffFactorKey, 0.5),
        (_rayRotationKey, 0.15),
        (_rayIntensityKey, 0.4),
        (_speedKey, 0.4),
      ],
      builder: (context, values) =>
          GyroBuilder(builder: (context, rotationX, rotationY) {
        return ShaderBuilder(
          (context, shader, child) {
            return AnimatedSampler(
              (image, size, canvas) {
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, (rotationX + 1) / 2)
                  ..setFloat(3, values.get(_verticalFalloffFactorKey))
                  ..setFloat(4, values.get(_horizontalFalloffFactorKey))
                  ..setFloat(5, values.get(_rayRotationKey))
                  ..setFloat(6, values.get(_rayIntensityKey))
                  ..setFloat(7, values.get(_speedKey))
                  ..setImageSampler(0, image);

                canvas.clipRRect(
                  RRect.fromRectAndRadius(
                    Offset.zero & size,
                    const Radius.circular(16),
                  ),
                );
                canvas.drawRect(
                  Offset.zero & size,
                  Paint()..shader = shader,
                );
              },
              child: child ?? SizedBox.shrink(),
            );
          },
          assetKey: 'shaders/light_reflection.frag',
          child: _CreditCard(),
        );
      }),
    );
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 230,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 24, 45, 83),
              Color.fromARGB(255, 49, 100, 188),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CREDIT CARD',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                '1234 5678 9012 3456',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CARD HOLDER',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Shiny Bob',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EXPIRES',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '01/25',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
