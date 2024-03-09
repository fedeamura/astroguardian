import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomScaleTap extends StatefulHookWidget {
  final CustomScaleTapInfo? info;
  final Function()? onPressed;
  final Function()? onTapDown;
  final Function()? onTapUp;

  final Function()? onLongPress;
  final Widget? child;
  final Duration? duration;
  final Alignment? alignment;
  final double? scaleMinPressedValue;
  final double? scaleMinHoverValue;

  final Curve? scaleCurve;
  final Decoration? decoration;
  final Decoration? pressedDecoration;
  final Decoration? hoveredDecoration;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool enabled;
  final double? minHeight;
  final double? maxWidth;
  final bool scale;

  const CustomScaleTap({
    super.key,
    this.onTapDown,
    this.onTapUp,
    this.hoveredDecoration,
    this.maxWidth,
    this.enabled = true,
    this.minHeight,
    this.info,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onPressed,
    this.onLongPress,
    this.child,
    this.duration,
    this.alignment,
    this.scaleMinPressedValue,
    this.scaleMinHoverValue,
    this.scaleCurve,
    this.decoration,
    this.pressedDecoration,
    this.scale = true,
  });

  @override
  State createState() => _CarbonScaleTapState();
}

class _CarbonScaleTapState extends State<CustomScaleTap> with SingleTickerProviderStateMixin {
  static const double _defaultScaleMinValue = 0.95;
  static const double _defaultScaleMinHoverValue = 0.97;

  static const Duration _defaultDuration = Duration(milliseconds: 300);
  static final Curve _defaultScaleCurve = CustomCurveSpring();

  CustomScaleTapInfo get _info => widget.info ?? CustomScaleTapInfo._default;

  bool _hover = false;
  bool _pressed = false;

  bool get _canBeClicked {
    if (widget.onPressed != null) return true;
    if (widget.onLongPress != null) return true;
    if (widget.onTapUp != null) return true;
    if (widget.onTapDown != null) return true;
    return false;
  }

  void _onTapDown() {
    if (!mounted) return;
    if (!_canBeClicked) return;
    if (_info.consumed == true) return;
    _info.consumed = true;
    widget.onTapDown?.call();

    setState(() => _pressed = true);
  }

  void _onTapUp() {
    if (!mounted) return;
    _info.consumed = false;

    widget.onTapUp?.call();
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    Decoration? decoration;
    if (_pressed) {
      decoration = widget.pressedDecoration ?? widget.decoration;
    } else if (_hover) {
      decoration = widget.hoveredDecoration ?? widget.decoration;
    } else {
      decoration = widget.decoration;
    }

    double scale = 1.0;
    if (widget.scale) {
      if (_pressed) {
        scale = widget.scaleMinPressedValue ?? _defaultScaleMinValue;
      } else if (_hover) {
        scale = widget.scaleMinHoverValue ?? _defaultScaleMinHoverValue;
      }
    }

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: MouseRegion(
        onEnter: _canBeClicked ? (event) => setState(() => _hover = true) : null,
        onExit: _canBeClicked ? (event) => setState(() => _hover = false) : null,
        cursor: _canBeClicked ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: widget.enabled ? 1.0 : 0.5,
            duration: widget.duration ?? _defaultDuration,
            child: AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: widget.minHeight ?? 0.0,
                maxWidth: widget.maxWidth ?? double.maxFinite,
              ),
              duration: widget.duration ?? _defaultDuration,
              margin: widget.margin,
              child: AnimatedScale(
                duration: widget.duration ?? _defaultDuration,
                scale: scale,
                curve: widget.scaleCurve ?? _defaultScaleCurve,
                child: Listener(
                  onPointerDown: (_) => _onTapDown(),
                  onPointerUp: (_) => _onTapUp(),
                  onPointerCancel: (_) => _onTapUp(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.onPressed != null ? () => widget.onPressed?.call() : null,
                    onLongPress: widget.onLongPress != null ? () => widget.onLongPress?.call() : null,
                    child: AnimatedContainer(
                      duration: widget.duration ?? _defaultDuration,
                      padding: widget.padding,
                      width: widget.width,
                      height: widget.height,
                      decoration: decoration,
                      clipBehavior: decoration != null ? Clip.hardEdge : Clip.none,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCurveSpring extends Curve {
  final SpringSimulation sim;

  CustomCurveSpring()
      : sim = SpringSimulation(
          SpringDescription.withDampingRatio(
            mass: 1,
            stiffness: 70.0,
            ratio: 0.7,
          ),
          0.0,
          1.0,
          0.0,
        );

  @override
  double transform(double t) => sim.x(t) + t * (1 - sim.x(1.0));
}

class CustomScaleTapInfo {
  CustomScaleTapInfo({
    required this.tag,
    this.consumed = false,
  });

  final String tag;
  bool consumed;

  static final _default = CustomScaleTapInfo(tag: "default");
}
