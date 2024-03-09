import 'dart:async';

import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:flutter/material.dart';

class GameHoldButton extends StatefulWidget {
  final Function()? callback;
  final Duration duration;
  final int tickCount;
  final Function()? onStart;
  final Function()? onEnd;
  final Function(double progress)? progressCallback;
  final EdgeInsets? margin;
  final String text;

  const GameHoldButton({
    super.key,
    this.callback,
    this.tickCount = 30,
    this.duration = const Duration(seconds: 3),
    this.onStart,
    this.onEnd,
    this.progressCallback, this.margin, required this.text,
  });

  @override
  State<GameHoldButton> createState() => _GameHoldButtonState();
}

class _GameHoldButtonState extends State<GameHoldButton> {
  double _progress = 0.0;

  Timer? _timer;
  int _count = 0;

  _onTapDown() {
    _cancel();
    widget.onStart?.call();
    _tick();
  }

  _onTapUp() => _cancel();

  _tick() {
    if (_count == widget.tickCount) {
      _cancel();
      widget.callback?.call();
      return;
    }

    final d = (widget.duration.inMilliseconds / widget.tickCount).floor();
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: d), () {
      setState(() {
        _count++;
        _progress = _count / widget.tickCount;
      });
      widget.progressCallback?.call(_progress);
      _tick();
    });
  }

  _cancel() {
    widget.onEnd?.call();
    _timer?.cancel();
    _timer = null;

    setState(() {
      _count = 0;
      _progress = 0;
    });

    widget.progressCallback?.call(_progress);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: double.infinity,
      height: 40,
      child: LayoutBuilder(builder: (context, constraints) {
        return GameButton(
          backgroundBuilder: (context) => Stack(
            alignment: Alignment.topLeft,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * _progress,
                color: Colors.amber,
                height: double.infinity,
              ),
            ],
          ),
          width: double.infinity,
          height: double.infinity,
          text: widget.text,
          onTapUp: _onTapUp,
          onTapDown: _onTapDown,
        );
      }),
    );
  }
}
