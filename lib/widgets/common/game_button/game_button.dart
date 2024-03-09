import 'package:astro_guardian/extensions/color.dart';
import 'package:astro_guardian/game/util/colors.dart';
import 'package:astro_guardian/widgets/common/game_message/game_message.dart';
import 'package:astro_guardian/widgets/common/scale_tap/scale_tap.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

class GameButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Function()? onTapDown;
  final Function()? onTapUp;
  final double? width;
  final Color? color;
  final Color? textColor;
  final bool enabled;
  final EdgeInsets? margin;
  final double? height;
  final Widget Function(BuildContext context)? backgroundBuilder;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final double? minHeight;
  final Widget Function(BuildContext context)? builder;

  const GameButton({
    super.key,
    this.text = "",
    this.onPressed,
    this.width,
    this.color,
    this.textColor,
    this.enabled = true,
    this.margin,
    this.onTapDown,
    this.onTapUp,
    this.height,
    this.backgroundBuilder,
    this.leftIcon,
    this.rightIcon,
    this.minHeight = 40.0,
    this.builder,
  });

  Color _lightenColor(BuildContext context, Color color, double amount) {
    if (color == Colors.transparent || color.opacity == 0.0) {
      return Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(amount) ?? Colors.black;
    }

    if (color == Colors.black) {
      return Colors.grey.shade900.lighten(amount);
    }

    return color.lighten(amount);
  }

  Color _contrastColor(BuildContext context, Color color) {
    if (color == Colors.transparent || color.opacity == 0.0) {
      return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    }

    return color.contrast();
  }

  Color _textColor(BuildContext context) {
    return textColor ?? _contrastColor(context, _color);
  }

  Color get _color {
    return color ?? GameColors.black;
  }

  Decoration _decoration(BuildContext context) {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: GameConstants.borderWidth,
          color: GameColors.white,
        ),
      ),
      color: _color,
    );
  }

  Decoration _hoverDecoration(BuildContext context) {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: GameConstants.borderWidth,
          color: GameColors.white,
        ),
      ),
      color: _lightenColor(context, _color, 0.1),
    );
  }

  Decoration _pressedDecoration(BuildContext context) {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: GameConstants.borderWidth,
          color: GameColors.white,
        ),
      ),
      color: _lightenColor(context, _color, 0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final withText = text.trim().isNotEmpty;

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: CustomScaleTap(
          margin: margin,
          onPressed: onPressed,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          decoration: _decoration(context),
          hoveredDecoration: _hoverDecoration(context),
          pressedDecoration: _pressedDecoration(context),
          minHeight: minHeight,
          width: width,
          height: height,
          child: DefaultTextStyle(
            style: TextStyle(
              color: _textColor(context),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (backgroundBuilder != null)
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: backgroundBuilder!.call(context),
                    ),
                  builder?.call(context) ??
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (leftIcon != null)
                              Container(
                                margin: EdgeInsets.only(right: withText ? 8.0 : 0.0),
                                child: Icon(leftIcon),
                              ),
                            Flexible(
                              child: GameMessage(
                                text: text,
                                height: 1.0,
                                color: _textColor(context),
                              ),
                            ),
                            if (rightIcon != null)
                              Container(
                                margin: EdgeInsets.only(left: withText ? 8.0 : 0.0),
                                child: Icon(rightIcon),
                              ),
                          ],
                        ),
                      ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
