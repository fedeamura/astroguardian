import 'package:flutter/material.dart';

class ColorOverlay extends StatelessWidget {
  final Widget child;

  final Color color;

  const ColorOverlay({
    super.key,
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.multiply,
        ),
        child: child,
      ),
    );
  }
}
