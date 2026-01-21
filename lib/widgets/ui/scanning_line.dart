import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class ScanningLine extends StatelessWidget {
  final double width;
  final double height;

  const ScanningLine({
    super.key,
    this.width = double.infinity,
    this.height = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(gradient: AppGradients.scanningLineGradient),
    );
  }
}
