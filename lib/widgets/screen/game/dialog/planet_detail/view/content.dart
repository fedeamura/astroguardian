import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/common/game_list_tile/game_list_tile.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/planets/view/planet_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:repository/repository.dart';

class GameDialogPlanetDetailContent extends StatefulHookWidget {
  final Animation<double> animation;
  final GameComponent game;
  final PlanetInfo planetInfo;

  const GameDialogPlanetDetailContent({
    super.key,
    required this.animation,
    required this.game,
    required this.planetInfo,
  });

  @override
  State<GameDialogPlanetDetailContent> createState() => _GameDialogPlanetDetailContentState();
}

class _GameDialogPlanetDetailContentState extends State<GameDialogPlanetDetailContent> {
  PlanetInfoRepository get _planetInfoRepository => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    final terrainSnapshot = useFuture(
      useMemoized(
        () => _planetInfoRepository.getTerrain(
          gameUid: widget.game.game.uid,
          planetUid: widget.planetInfo.uid,
        ),
        [widget.game.game.uid, widget.planetInfo.uid],
      ),
    );
    final terrain = terrainSnapshot.data;
    final isMarked = widget.game.game.mapMarkerTag == "map_${widget.planetInfo.uid}";

    return GameDialogContent(
      animation: widget.animation,
      game: widget.game,
      title: "Planet detail",
      closeButtonVisible: true,
      onCloseButtonPressed: () => Navigator.of(context).maybePop(),
      onBackgroundPressed: () => Navigator.of(context).maybePop(),
      builder: (context) => Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: terrain != null
                  ? PlanetPreview(
                      key: const ValueKey("terrain"),
                      gameUid: widget.game.game.uid,
                      planet: widget.planetInfo,
                      terrain: terrain,
                    )
                  : Container(
                      key: const ValueKey("empty"),
                    ),
            ),
          ),
          const SizedBox(height: 32.0),
          GameListTile(
            title: "Completed",
            message: "${(widget.planetInfo.percentage * 100).toStringAsFixed(0)}%",
          ),
          const SizedBox(height: 8.0),
          GameListTile(
            title: "Discovered at",
            message: DateTime.fromMillisecondsSinceEpoch(widget.planetInfo.createdAt).toString(),
          ),
          const SizedBox(height: 8.0),
          GameListTile(
            title: "Updated at",
            message: DateTime.fromMillisecondsSinceEpoch(widget.planetInfo.updatedAt).toString(),
          ),
          const SizedBox(height: 32.0),
          GameButton(
            width: double.infinity,
            text: isMarked ? "REMOVE MARKER" : "ADD MARKER",
            onPressed: _toggleMap,
          )
        ],
      ),
    );
  }

  _toggleMap() async {
    final markTag = "map_${widget.planetInfo.uid}";
    final g = widget.game.game;
    if (g.mapMarkerTag == markTag) {
      g.mapMarkerTag = "";
      g.mapMarkerVisible = false;
    } else {
      g.mapMarker = widget.planetInfo.position;
      g.mapMarkerVisible = true;
      g.mapMarkerTag = markTag;
    }
    await widget.game.save();
    setState(() {});
  }
}
