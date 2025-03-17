import 'package:flutter/material.dart';

class AppTile extends StatefulWidget {
  const AppTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  State<AppTile> createState() => AppTileState();
}

class AppTileState extends State<AppTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) => Transform.scale(
            scale: _hoverAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                boxShadow: _hoverAnimation.value > 0.5
                    ? [
                        BoxShadow(
                          color: const Color.fromARGB(40, 0, 0, 0),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 51, 51, 51),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9A9A9A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
