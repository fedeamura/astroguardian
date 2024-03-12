import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class CustomShaderNoise extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final ValueNotifier<double>? percentage;

  const CustomShaderNoise({
    super.key,
    required this.child,
    this.enabled = true,
    this.percentage,
  });

  @override
  State<CustomShaderNoise> createState() => _CustomShaderNoiseState();
}

class _CustomShaderNoiseState extends State<CustomShaderNoise> with SingleTickerProviderStateMixin {
  Ticker? _ticker;
  ui.Image? _image;
  ui.FragmentShader? _shader;
  double _delta = 0;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _init());
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  _init() async {
    if (!kIsWeb) {
      final program = await ui.FragmentProgram.fromAsset('shaders/noise.frag');
      _shader = program.fragmentShader();

      _ticker = createTicker((elapsed) {
        _createImage(elapsed.inMilliseconds);
      });
      _ticker?.start();
    }
  }

  _createImage(delta) async {
    if (!widget.enabled) {
      if (_image != null) {
        setState(() => _image = null);
      }
      return;
    }

    _delta = (_delta + delta) % 500;

    try {
      final boundary = _key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = boundary.toImageSync();

      _shader?.setImageSampler(0, image);
      _shader?.setFloat(0, image.width.toDouble());
      _shader?.setFloat(1, image.height.toDouble());
      _shader?.setFloat(2, _delta);
      _shader?.setFloat(3, widget.percentage?.value ?? 1.0);
      _shader?.setFloat(4, 0.8);
      _shader?.setFloat(5, 0.3);

      if (mounted) {
        setState(() => _image = image);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final withShader = _image != null && _shader != null;

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            key: _key,
            child: widget.child,
          ),
        ),
        if (withShader)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        if (withShader)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: CustomPaint(
                painter: _ShaderPainter(_shader),
              ),
            ),
          )
      ],
    );
  }
}

class _ShaderPainter extends CustomPainter {
  final ui.FragmentShader? shader;

  _ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_ShaderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_ShaderPainter oldDelegate) => false;
}
