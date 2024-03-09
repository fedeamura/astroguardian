import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:util/util.dart';

class GameShakeAnimation extends StatefulWidget {
  final Widget widget;
  final bool enabled;
  final double intensity;
  final double intensityScale;
  final double maxIntensity;

  const GameShakeAnimation({
    super.key,
    required this.widget,
    this.enabled = true,
    this.intensity = 0.01,
    this.intensityScale = 1.05,
    this.maxIntensity = 0.07,
  });

  @override
  State<GameShakeAnimation> createState() => _GameShakeAnimationState();
}

class _GameShakeAnimationState extends State<GameShakeAnimation> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    lowerBound: -1.0,
    upperBound: 1.0,
    value: 0.0,
  );

  bool _dir = true;
  final _rnd = RandomUtil();

  double _horizontalIntensity = 0.0;
  double _verticalIntensity = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => FractionalTranslation(
          translation: Offset(
            _horizontalIntensity * _animationController.value,
            _verticalIntensity * _animationController.value,
          ),
          child: child,
        ),
        child: widget.widget,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener(_onAnimationStatusChanged);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _init());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GameShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      _process();
    }
  }

  _onAnimationStatusChanged(AnimationStatus status) {
    log("Animation status changed $status");
    if (!widget.enabled) return;
    if (status == AnimationStatus.completed) {
      _dir = !_dir;
      _calculateIntensity();
      _updateAnimation();
    }
  }

  _init() {
    if (widget.enabled) {
      _process();
    }
  }

  _process() {
    _dir = RandomUtil().nextDouble() > 0.5;

    _calculateIntensity();
    _updateAnimation();
  }

  _calculateIntensity() {
    final rx = _rnd.nextDouble() * widget.intensity;
    final ry = _rnd.nextDouble() * widget.intensity;

    var ix = rx * widget.intensityScale;
    ix = ix.clamp(0.0, widget.maxIntensity);

    var iy = ry * widget.intensityScale;
    iy = iy.clamp(0.0, widget.maxIntensity);

    _horizontalIntensity = ix;
    _verticalIntensity = iy;
  }

  _updateAnimation() {
    if (widget.enabled) {
      final value = _dir ? 1.0 : -1.0;
      _animationController.animateTo(
        value,
        duration: const Duration(milliseconds: 50),
        curve: Curves.elasticOut,
      );
    } else {
      _animationController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 50),
        curve: Curves.decelerate,
      );
    }
  }
}
