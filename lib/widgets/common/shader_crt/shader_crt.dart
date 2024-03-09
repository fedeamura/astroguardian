import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class CustomShaderCRT extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double distortion;
  final double scanAmplitude;
  final double scanFrequency;
  final double scanVelocity;
  final double scanMultiplier;

  const CustomShaderCRT({
    super.key,
    required this.child,
    this.distortion = 0.01,
    this.scanVelocity = 0.3,
    this.scanAmplitude = 0.3,
    this.scanFrequency = 0.3,
    this.scanMultiplier = 0.3,
    this.enabled = true,
  });

  @override
  State<CustomShaderCRT> createState() => _CustomShaderCRTState();
}

class _CustomShaderCRTState extends State<CustomShaderCRT> with SingleTickerProviderStateMixin {
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
      final program = await ui.FragmentProgram.fromAsset('shaders/crt.frag');
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

    _delta += delta;

    try {
      final boundary = _key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = boundary.toImageSync();

      _shader?.setImageSampler(0, image);
      _shader?.setFloat(0, image.width.toDouble());
      _shader?.setFloat(1, image.height.toDouble());
      _shader?.setFloat(2, _delta % 5);
      _shader?.setFloat(3, 0.001);
      _shader?.setFloat(4, widget.distortion);
      _shader?.setFloat(5, 0.15);
      _shader?.setFloat(6, widget.scanFrequency);
      _shader?.setFloat(7, widget.scanAmplitude);
      _shader?.setFloat(8, widget.scanVelocity);
      _shader?.setFloat(9, widget.scanMultiplier);

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
