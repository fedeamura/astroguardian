import 'dart:async';

import 'package:flutter/scheduler.dart';

final SchedulerBinding a = SchedulerBinding.instance;

extension SchedulerBindingExtension on SchedulerBinding {
  Future<void> waitPostFrame() {
    final completer = Completer();
    addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 0));
      completer.complete();
    });

    return completer.future;
  }
}
