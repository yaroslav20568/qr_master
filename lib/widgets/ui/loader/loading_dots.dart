import 'package:flutter/material.dart';
import 'package:qr_master/widgets/ui/dot.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;
            final offset = value < 0.5 ? value * 2 : 2 - (value * 2);
            final yOffset = -offset * 4;
            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
              child: Transform.translate(
                offset: Offset(0, yOffset),
                child: const Dot(),
              ),
            );
          },
        );
      }),
    );
  }
}
