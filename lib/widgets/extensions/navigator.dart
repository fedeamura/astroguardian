import 'package:flutter/material.dart';

extension NavigatorExtension on NavigatorState {
  Future<T?> openDialog<T>(Widget Function(Animation<double> animation) builder) {
    return push<T>(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => builder(animation),
        opaque: false,
      ),
    );
  }

  Future<T?> screenReplace<T>(Widget child) {
    return pushAndRemoveUntil<T>(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => child,
      ),
      (route) => false,
    );
  }
}
