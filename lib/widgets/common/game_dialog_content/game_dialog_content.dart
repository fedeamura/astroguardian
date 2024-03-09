import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/colors.dart';
import 'package:astro_guardian/widgets/common/game_title/game_title.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

import 'base_overlay.dart';

class GameDialogContent extends StatelessWidget {
  final Animation<double> animation;
  final GameComponent? game;
  final Function()? onBackgroundPressed;
  final Function()? onCloseButtonPressed;
  final bool closeButtonVisible;
  final String title;
  final Widget Function(BuildContext context)? builder;
  final TextAlign? titleTextAlign;
  final Alignment? titleAlignment;
  final bool scrollable;
  final Widget Function(BuildContext context, Widget child)? wrapper;

  const GameDialogContent({
    super.key,
    this.game,
    this.scrollable = true,
    this.builder,
    this.title = "",
    this.onBackgroundPressed,
    this.onCloseButtonPressed,
    this.closeButtonVisible = false,
    this.titleTextAlign,
    this.titleAlignment,
    this.wrapper,
    required this.animation,
  });

  Widget _gameWrapper({required Widget child}) {
    if (game != null) {
      return GameBaseOverlay(
        game: game!,
        child: child,
      );
    }

    return child;
  }

  Widget _wrapper(BuildContext context, {required Widget child}) {
    if (wrapper != null) {
      return wrapper!(context, child);
    }

    return child;
  }

  Widget _scrollWrapper({required Widget child}) {
    if (scrollable) {
      return SingleChildScrollView(
        child: child,
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.paddingOf(context);

    return Material(
      color: Colors.transparent,
      child: _gameWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onBackgroundPressed,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    var curve = Curves.decelerate;
                    if (animation.status == AnimationStatus.forward) {
                      curve = Interval(0.0, 0.3, curve: curve);
                    } else {
                      curve = curve.flipped;
                    }

                    final opacityTween = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      ),
                    );

                    return Opacity(
                      opacity: opacityTween.value.clamp(0.0, 1.0),
                      child: child,
                    );
                  },
                  child: Container(
                    color: GameColors.darker,
                  ),
                ),
              ),
            ),
            Positioned(
              left: p.left + 16,
              right: p.right + 16,
              top: p.top + 16,
              bottom: p.bottom + 16,
              child: Center(
                child: _wrapper(
                  context,
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      const curve = Curves.elasticOut;
                      const curveOpacity = Curves.decelerate;
                      final scaleTween = Tween(begin: 0.7, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: animation.status == AnimationStatus.reverse ? curveOpacity.flipped : curve,
                        ),
                      );

                      final opacityTween = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: animation.status == AnimationStatus.reverse ? curveOpacity.flipped : curveOpacity,
                        ),
                      );

                      return Opacity(
                        opacity: opacityTween.value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: scaleTween.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 450,
                        maxHeight: 600,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: GameColors.black,
                        border: Border.all(
                          color: GameColors.white,
                          width: GameConstants.borderWidth,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title.trim().isNotEmpty)
                            GameTitle(
                              margin: const EdgeInsets.all(16.0),
                              title: title.toUpperCase(),
                              closeButtonVisible: closeButtonVisible,
                              onCloseButtonPressed: onCloseButtonPressed,
                              textAlign: titleTextAlign,
                              alignment: titleAlignment,
                            ),
                          Flexible(
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              child: _scrollWrapper(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                  ),
                                  child: builder?.call(context) ?? Container(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
