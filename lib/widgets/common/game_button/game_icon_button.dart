import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const String _imageX = '''
x...x
.x.x.
..x..
.x.x.
x...x
''';

class GameIconButton extends HookWidget {
  final String imageData;
  final Function()? onPressed;
  final bool enabled;
  final bool borderVisible;

  const GameIconButton({
    super.key,
    this.onPressed,
    this.enabled = true,
    this.borderVisible = true,
    this.imageData = "",
  });

  const GameIconButton.x({
    super.key,
    this.onPressed,
    this.enabled = true,
    this.borderVisible = true,
    this.imageData = _imageX,
  });

  @override
  Widget build(BuildContext context) {
    final image = useMemoized(
      () {
        if (imageData.trim().isEmpty) return null;
        return ImagePainterUtil.drawPixelsString(paint: Paint()..color = Colors.white, data: imageData);
      },
      [imageData],
    );

    return GameButton(
      enabled: enabled,
      width: 35.0,
      height: 35.0,
      minHeight: 35,
      onPressed: onPressed,
      backgroundBuilder: (context) => Container(
        margin: const EdgeInsets.all(8.0),
        child: RawImage(
          image: image,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      ),
    );
  }
}
