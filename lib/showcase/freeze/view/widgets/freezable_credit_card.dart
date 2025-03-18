import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class FreezableCreditCard extends StatefulWidget {
  const FreezableCreditCard({
    super.key,
    required this.isFrozen,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  });

  final bool isFrozen;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  @override
  State<FreezableCreditCard> createState() => _FreezableCreditCardState();
}

class _FreezableCreditCardState extends State<FreezableCreditCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 5.0, end: 0.45).animate(_animationController);
    if (widget.isFrozen) {
      _animationController.forward(from: 1.0);
    }
  }

  @override
  void didUpdateWidget(covariant FreezableCreditCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFrozen != oldWidget.isFrozen) {
      if (widget.isFrozen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ShaderBuilder(
          (context, shader, child) {
            return AnimatedSampler(
              (image, size, canvas) {
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, _animation.value)
                  ..setFloat(3, size.width - 30)
                  ..setFloat(4, size.height - 30)
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
          assetKey: 'shaders/freeze.frag',
          child: _CreditCard(
            cardNumber: widget.cardNumber,
            cardHolder: widget.cardHolder,
            expiryDate: widget.expiryDate,
          ),
        );
      },
    );
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  });

  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
            const SizedBox(height: 20),
            Text(
              cardNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
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
                      cardHolder,
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
                      expiryDate,
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
    );
  }
}
