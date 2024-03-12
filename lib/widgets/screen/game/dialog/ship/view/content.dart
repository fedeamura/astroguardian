import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/common/game_list_tile/game_list_tile.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/ship_ability/ship_ability.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class GameDialogShipContent extends StatefulWidget {
  final Animation<double> animation;
  final GameComponent game;

  const GameDialogShipContent({
    super.key,
    required this.animation,
    required this.game,
  });

  @override
  State<GameDialogShipContent> createState() => _GameDialogShipContentState();
}

class _GameDialogShipContentState extends State<GameDialogShipContent> {
  @override
  Widget build(BuildContext context) {
    final game = widget.game.game;
    final abilities = game.ship.abilities.entries.toList();
    final points = game.ship.pendingAbilityPoints;

    return GameDialogContent(
      animation: widget.animation,
      game: widget.game,
      title: "Ship",
      closeButtonVisible: true,
      onCloseButtonPressed: Navigator.of(context).pop,
      onBackgroundPressed: Navigator.of(context).pop,
      builder: (context) => Column(
        children: [
          if (points > 0)
            GameListTile(
              margin: const EdgeInsets.only(bottom: 32),
              title: "Ability points",
              trailingText: points.toStringAsFixed(0),
              trailingIcon: Icons.keyboard_arrow_right,
              selected: true,
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final ability = abilities[index].key;
              final step = abilities[index].value;
              return GameListTile(
                title: ability.displayName,
                trailingText: "${step.level + 1}/${step.maxLevel + 1}",
                trailingIcon: Icons.keyboard_arrow_right,
                onPressed: () => _openAbility(ability),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemCount: abilities.length,
          ),
        ],
      ),
    );
  }

  _openAbility(ShipAbility ability) async {
    final result = await showGameDialogShipAbility(
      context,
      game: widget.game,
      shipAbility: ability,
    );
    if (!mounted) return;
    setState(() {});

    if (result == true) {
      Navigator.of(context).pop();
    }
  }
}
