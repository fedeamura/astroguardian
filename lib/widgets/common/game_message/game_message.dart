import 'package:flutter/material.dart';

class GameMessage extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final double textSize;
  final double height;
  final EdgeInsets? margin;

  const GameMessage({
    super.key,
    this.text = "",
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.textSize = 12.0,
    this.margin,
    this.height = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontFamily: "Pixelify",
          fontSize: textSize,
          color: color,
          height: height,
        ),
      ),
    );
  }
}
