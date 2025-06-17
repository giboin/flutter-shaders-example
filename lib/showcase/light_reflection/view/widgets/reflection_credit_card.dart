import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/gyro_builder.dart';
import 'package:flutter_shaders_example/showcase/shared/widgets/playground.dart';
import 'package:sensors_plus/sensors_plus.dart';

const _verticalFalloffFactorKey = 'vertical falloff';
const _rayRotationKey = 'ray rotation';
const _horizontalFalloffFactorKey = 'horizontal falloff';
const _rayIntensityKey = 'ray intensity';
const _debounceFactorKey = 'debounce factor';
const _speedKey = 'speed';

class ReflectionCreditCard extends StatelessWidget {
  const ReflectionCreditCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Playground(
      valuesToPlayWith: [
        (_speedKey, 0.5),
        (_debounceFactorKey, 0.4),
        (_rayRotationKey, 0.15),
        (_rayIntensityKey, 0.4),
        (_verticalFalloffFactorKey, 0.5),
        (_horizontalFalloffFactorKey, 0.5),
      ],
      builder: (context, values) => GyroBuilder(
        samplingPeriod: SensorInterval.gameInterval,
        builder: (context, rotationX, _) {
          return ShaderBuilder(
            (context, shader, child) {
              final progress =
                  (rotationX + 10) / 20 * values.get(_speedKey) * 2;

              return AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setFloat(0, size.width)
                    ..setFloat(1, size.height)
                    ..setFloat(2, progress)
                    ..setFloat(3, values.get(_debounceFactorKey) * 5)
                    ..setFloat(4, values.get(_rayRotationKey))
                    ..setFloat(5, values.get(_rayIntensityKey))
                    ..setFloat(6, values.get(_verticalFalloffFactorKey))
                    ..setFloat(7, values.get(_horizontalFalloffFactorKey))
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
        },
      ),
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
          color: Color(0xFFFF2B44),
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
