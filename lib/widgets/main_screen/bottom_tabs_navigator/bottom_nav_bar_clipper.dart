import 'package:flutter/material.dart';

class BottomNavBarClipper extends CustomClipper<Path> {
  final double screenWidth;

  const BottomNavBarClipper({required this.screenWidth});

  @override
  Path getClip(Size size) {
    final path = Path();
    final fabCenterX = size.width / 2;
    final svgFabCenterX = 187.0;
    final svgBaseY = 44.0;
    final scale = size.width / screenWidth;

    double toX(double svgX) => (svgX - svgFabCenterX) * scale + fabCenterX;
    double toY(double svgY) => (svgY - svgBaseY) * scale;

    path.moveTo(0, 0);
    path.lineTo(toX(131.095), 0);

    path.cubicTo(
      toX(137.124),
      0,
      toX(142.831),
      toY(46.7194),
      toX(146.628),
      toY(51.4015),
    );

    path.lineTo(toX(160.166), toY(68.0933));

    path.cubicTo(
      toX(175.727),
      toY(87.2783),
      toX(205.358),
      toY(86.1192),
      toX(219.372),
      toY(65.7774),
    );

    path.lineTo(toX(228.413), toY(52.6534));

    path.cubicTo(toX(232.146), toY(47.2356), toX(238.304), 0, toX(244.883), 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
