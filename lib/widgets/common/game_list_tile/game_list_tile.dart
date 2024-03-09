import 'package:astro_guardian/extensions/color.dart';
import 'package:astro_guardian/game/util/colors.dart';
import 'package:astro_guardian/widgets/common/game_message/game_message.dart';
import 'package:astro_guardian/widgets/common/scale_tap/scale_tap.dart';
import 'package:flutter/material.dart';

class GameListTile extends StatelessWidget {
  final String title;
  final String message;
  final EdgeInsets? padding;
  final Function()? onPressed;
  final Function()? onLongPressed;
  final String trailingText;
  final IconData? trailingIcon;
  final Widget Function(BuildContext context)? trailingBuilder;
  final String leadingText;
  final IconData? leadingIcon;
  final Widget Function(BuildContext context)? leadingBuilder;
  final Function()? playAudio;
  final Color? color;
  final Color? textColor;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final bool selected;
  final EdgeInsets? margin;
  final double? leadingIconMargin;
  final Widget Function(BuildContext context)? builder;

  const GameListTile({
    super.key,
    this.title = "",
    this.message = "",
    this.padding,
    this.onPressed,
    this.playAudio,
    this.color,
    this.selected = false,
    this.margin,
    this.trailingText = "",
    this.trailingBuilder,
    this.leadingText = "",
    this.leadingBuilder,
    this.onLongPressed,
    this.selectedColor,
    this.trailingIcon,
    this.leadingIcon,
    this.textColor,
    this.selectedTextColor,
    this.leadingIconMargin,
    this.builder,
  });

  Color _lightenColor(BuildContext context, Color color, double amount) {
    if (color == Colors.transparent || color.opacity == 0.0) {
      return Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(amount) ?? Colors.black;
    }

    return color.lighten(amount);
  }

  Color _contrastColor(BuildContext context, Color color) {
    if (color == Colors.transparent || color.opacity == 0.0) {
      return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    }

    return color.contrast();
  }

  Color get _color {
    if (selected) {
      return selectedColor ?? Colors.amber;
    }

    return color ?? GameColors.darker;
  }

  Color _textColor(BuildContext context) {
    if (selected) {
      return selectedColor ?? textColor ?? _contrastColor(context, _color);
    }

    return textColor ?? _contrastColor(context, _color);
  }

  Decoration get _defaultDecoration {
    return ShapeDecoration(
      shape: const RoundedRectangleBorder(),
      color: _color,
    );
  }

  Decoration _hoverDecoration(BuildContext context) {
    return ShapeDecoration(
      shape: const RoundedRectangleBorder(),
      color: _lightenColor(context, _color, 0.1),
    );
  }

  Decoration _pressedDecoration(BuildContext context) {
    return ShapeDecoration(
      shape: const RoundedRectangleBorder(),
      color: _lightenColor(context, _color, 0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor(context);

    return CustomScaleTap(
      margin: margin,
      decoration: _defaultDecoration,
      hoveredDecoration: _hoverDecoration(context),
      pressedDecoration: _pressedDecoration(context),
      onPressed: onPressed != null
          ? () {
              playAudio?.call();
              onPressed?.call();
            }
          : null,
      onLongPress: onLongPressed != null
          ? () {
              playAudio?.call();
              onLongPressed?.call();
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(16.0),
        child: IconTheme(
          data: IconThemeData(
            color: textColor,
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: textColor),
            child: builder?.call(context) ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingText.trim().isNotEmpty || leadingBuilder != null || leadingIcon != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            if (leadingIcon != null)
                              Container(
                                margin: EdgeInsets.only(
                                  right: leadingIconMargin ?? 0.0,
                                ),
                                child: Icon(
                                  leadingIcon,
                                  size: 15,
                                ),
                              ),
                            leadingBuilder?.call(context) ??
                                GameMessage(
                                  text: leadingText,
                                  textSize: 10,
                                  height: 1.0,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: textColor,
                                ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (title.trim().isNotEmpty)
                            GameMessage(
                              text: title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              height: 1.0,
                              color: textColor,
                            ),
                          if (title.trim().isNotEmpty && message.trim().isNotEmpty) const SizedBox(height: 4.0),
                          if (message.trim().isNotEmpty)
                            GameMessage(
                              text: message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textSize: 10,
                              color: textColor,
                            ),
                        ],
                      ),
                    ),
                    if (trailingText.trim().isNotEmpty || trailingBuilder != null)
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            trailingBuilder?.call(context) ??
                                GameMessage(
                                  text: trailingText,
                                  textSize: 10,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.0,
                                  color: textColor,
                                ),
                            if (trailingIcon != null) Icon(trailingIcon!),
                          ],
                        ),
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
