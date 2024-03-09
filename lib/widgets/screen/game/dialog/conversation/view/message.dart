import 'dart:async';

import 'package:astro_guardian/widgets/common/game_message/game_message.dart';
import 'package:flutter/material.dart';

class MovingMessage extends StatefulWidget {
  final String message;

  const MovingMessage({
    super.key,
    required this.message,
  });

  @override
  State<MovingMessage> createState() => _MovingMessageState();
}

class _MovingMessageState extends State<MovingMessage> {
  int _index = 0;
  String _message = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topLeft,
      child: GameMessage(text: _message),
    );
  }

  @override
  void didUpdateWidget(covariant MovingMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      _init();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _init());
  }

  _init() {
    setState(() {
      _index = 0;
      _message = "";
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final isComplete = _index == widget.message.length;
      if (isComplete) {
        _timer?.cancel();
        return;
      }

      setState(() {
        _index++;
        _message = widget.message.substring(0, _index);
      });
    });
  }
}
