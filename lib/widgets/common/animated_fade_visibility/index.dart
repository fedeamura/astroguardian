import 'package:flutter/material.dart';

class CustomAnimatedFadeVisibility extends StatelessWidget {
  final Widget child;
  final bool visible;

  const CustomAnimatedFadeVisibility({
    super.key,
    required this.child,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}
