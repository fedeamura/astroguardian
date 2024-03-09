import 'package:astro_guardian/widgets/common/game_button/game_icon_button.dart';
import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  final String title;
  final Alignment? alignment;
  final bool closeButtonVisible;
  final Function()? onCloseButtonPressed;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const GameTitle({
    super.key,
    this.title = "",
    this.onCloseButtonPressed,
    this.textAlign,
    this.alignment,
    this.closeButtonVisible = false,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: alignment ?? Alignment.centerLeft,
              child: Text(
                title,
                textAlign: textAlign ?? TextAlign.left,
                style: const TextStyle(
                  fontFamily: "Pixelify",
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (closeButtonVisible)
            GameIconButton.x(
              onPressed: onCloseButtonPressed,
            ),
        ],
      ),
    );
  }
}
