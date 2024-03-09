import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/animated_collapse_visibility/index.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/common/game_hold_button/game_hold_button.dart';
import 'package:astro_guardian/widgets/common/game_list_tile/game_list_tile.dart';
import 'package:astro_guardian/widgets/common/game_message/game_message.dart';
import 'package:astro_guardian/widgets/common/shake/shake.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';
import 'package:model/model.dart';

class GameDialogShipAbilityContent extends StatefulWidget {
  final GameComponent game;
  final ShipAbility shipAbility;
  final Animation<double> animation;

  const GameDialogShipAbilityContent({
    super.key,
    required this.game,
    required this.shipAbility,
    required this.animation,
  });

  @override
  State<GameDialogShipAbilityContent> createState() => _GameDialogShipAbilityContentState();
}

class _GameDialogShipAbilityContentState extends State<GameDialogShipAbilityContent> {
  double _progress = 0.0;
  bool _shakeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final game = widget.game.game;
    final level = game.ship.abilities[widget.shipAbility]?.level ?? 0;
    final maxLevel = game.ship.abilities[widget.shipAbility]?.maxLevel ?? 0;
    final value = game.ship.abilities[widget.shipAbility]?.value ?? 0;
    final withPoints = game.ship.pendingAbilityPoints > 0;
    final canBeUpgraded = level < maxLevel;
    final buttonUpgradeVisible = withPoints && canBeUpgraded;

    return GameDialogContent(
      animation: widget.animation,
      game: widget.game,
      title: widget.shipAbility.displayName,
      closeButtonVisible: true,
      onCloseButtonPressed: Navigator.of(context).pop,
      onBackgroundPressed: Navigator.of(context).pop,
      wrapper: (context, child) => GameShakeAnimation(
        enabled: _shakeEnabled,
        widget: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: MathRangeUtil.range(
            _progress,
            0.0,
            1.0,
            1.0,
            1.25,
          ),
          curve: Curves.elasticOut,
          child: child,
        ),
      ),
      builder: (context) => Column(
        children: [
          GameMessage(
            text: widget.shipAbility.description,
          ),
          const SizedBox(height: 32.0),
          GameListTile(
            title: "Level",
            trailingText: "${level + 1}/${maxLevel + 1}",
          ),
          const SizedBox(height: 8.0),
          GameListTile(
            title: widget.shipAbility.valueLabel,
            trailingText: value.toStringAsFixed(0),
          ),
          CustomAnimatedCollapseVisibility(
            visible: buttonUpgradeVisible,
            child: GameHoldButton(
              margin: const EdgeInsets.only(top: 32.0),
              text: "Hold to upgrade",
              callback: _upgrade,
              progressCallback: (progress) => setState(() => _progress = progress),
              onStart: () => setState(() => _shakeEnabled = true),
              onEnd: () => setState(() => _shakeEnabled = false),
            ),
          )
        ],
      ),
    );
  }

  _upgrade() async {
    final upgraded = widget.game.gameService.increaseShipAbility(
      widget.game.game,
      widget.shipAbility,
    );
    if (upgraded) {
      widget.game.save();

      // await showGameDialogConfirmation(
      //   context,
      //   title: "",
      //   message: "${ability.displayName} upgraded!",
      //   yesButton: "Accept",
      //   noButtonVisible: false,
      // );
      final game = widget.game.game;
      final conversations = game.conversations;
      final inTutorial = game.tutorial && conversations[ConversationType.tutorialImproveShip] != true;

      if (inTutorial) {
        Navigator.of(context).pop(true);
      }
    }
  }
}
