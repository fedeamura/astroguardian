import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/game_list_tile/game_list_tile.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/planet_detail/index.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:repository/repository.dart';

import 'content.dart';
import 'planet_preview.dart';

class PlanetListItem extends StatefulWidget {
  final GameComponent game;
  final PlanetInfo planetInfo;
  final bool isGrid;

  const PlanetListItem({
    super.key,
    required this.game,
    required this.planetInfo,
    this.isGrid = true,
  });

  @override
  State<PlanetListItem> createState() => _PlanetListItemState();
}

class _PlanetListItemState extends State<PlanetListItem> {
  PlanetInfoRepository get _planetInfoRepository => GetIt.I.get();
  PlanetTerrain? _terrain;

  @override
  Widget build(BuildContext context) {
    if (widget.isGrid) {
      return AspectRatio(
        aspectRatio: 1.0,
        child: GameListTile(
          onPressed: () => _onPlanetPressed(),
          builder: (context) => Stack(
            children: [
              Positioned.fill(
                child: PlanetPreview(
                  gameUid: widget.game.game.uid,
                  planet: widget.planetInfo,
                  terrain: _terrain,
                ),
              ),

              Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: Colors.grey.shade600,
                  ),
                  child: Text(
                    "${(widget.planetInfo.percentage * 100).toStringAsFixed(0)}%",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GameListTile(
      onPressed: () => _onPlanetPressed(),
      builder: (context) => Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: PlanetPreview(
              gameUid: widget.game.game.uid,
              planet: widget.planetInfo,
              terrain: _terrain,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${(widget.planetInfo.percentage * 100).toStringAsFixed(0)}% completed"),
                Text(DateTime.fromMillisecondsSinceEpoch(widget.planetInfo.createdAt).toIso8601String()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _fetch());
  }

  _fetch() async {
    if (!mounted) return;

    final gameUid = widget.game.game.uid;
    final uid = "${gameUid}_${widget.planetInfo.uid}";
    final cache = planetPreviewCache[uid];
    if (cache != null) {
      setState(() => _terrain = cache);
    } else {
      final fetched = await _planetInfoRepository.getTerrain(
        gameUid: gameUid,
        planetUid: widget.planetInfo.uid,
      );
      if (mounted && fetched != null) {
        planetPreviewCache[uid] = fetched;
        setState(() => _terrain = fetched);
      }
    }
  }

  _onPlanetPressed() {
    showGameDialogPlanetDetail(
      context,
      game: widget.game,
      planetInfo: widget.planetInfo,
    );
  }
}
