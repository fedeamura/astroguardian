import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/planets/view/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:repository/repository.dart';

var planetPreviewCache = <String, PlanetTerrain>{};

enum _Sort {
  updated,
  created,
  percentage;

  String get displayName {
    switch (this) {
      case _Sort.updated:
        return "Updated";
      case _Sort.created:
        return "Discovered";
      case _Sort.percentage:
        return "Percentage";
    }
  }
}

class GameDialogPlanetsContent extends StatefulHookWidget {
  final Animation<double> animation;
  final GameComponent game;

  const GameDialogPlanetsContent({
    super.key,
    required this.animation,
    required this.game,
  });

  @override
  State<GameDialogPlanetsContent> createState() => _GameDialogPlanetsContentState();
}

class _GameDialogPlanetsContentState extends State<GameDialogPlanetsContent> {
  var _data = <PlanetInfo>[];
  var _sort = _Sort.updated;

  PlanetInfoRepository get _planetInfoRepository => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    final sorted = useMemoized(
      () {
        final data = _data.toList();
        switch (_sort) {
          case _Sort.updated:
            data.sort((a, b) {
              final d1 = DateTime.fromMillisecondsSinceEpoch(a.updatedAt);
              final d2 = DateTime.fromMillisecondsSinceEpoch(b.updatedAt);
              return d2.compareTo(d1);
            });
            break;

          case _Sort.created:
            data.sort((a, b) {
              final d1 = DateTime.fromMillisecondsSinceEpoch(a.createdAt);
              final d2 = DateTime.fromMillisecondsSinceEpoch(b.createdAt);
              return d2.compareTo(d1);
            });
            break;

          case _Sort.percentage:
            data.sort((a, b) {
              final p1 = a.percentage;
              final p2 = b.percentage;
              return p2.compareTo(p1);
            });
            break;
        }
        return data;
      },
      [_data, _sort],
    );

    return GameDialogContent(
      animation: widget.animation,
      game: widget.game,
      closeButtonVisible: true,
      onCloseButtonPressed: () => Navigator.of(context).pop(),
      onBackgroundPressed: () => Navigator.of(context).pop(),
      title: "Planets",
      scrollable: false,
      builder: (context) => Column(
        children: [
          GameButton(
            width: double.infinity,
            text: _sort.displayName,
            leftIcon: Icons.sort,
            onPressed: () {
              final index = (_sort.index + 1) % _Sort.values.length;
              setState(() => _sort = _Sort.values[index]);
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(child: _buildGrid(sorted)),
        ],
      ),
    );
  }

  Widget _buildGrid(List<PlanetInfo> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1.0,
        mainAxisSpacing: 16.0,
      ),
      itemBuilder: (context, index) => PlanetListItem(
        key: ValueKey(items[index].uid),
        game: widget.game,
        planetInfo: items[index],
        isGrid: true,
      ),
      itemCount: items.length,
    );
  }

  _fetch() async {
    if (!mounted) return;
    final data = await _planetInfoRepository.getAll(widget.game.game.uid);
    if (!mounted) return;
    setState(() => _data = data);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _fetch());
  }

  @override
  void dispose() {
    planetPreviewCache.clear();
    super.dispose();
  }
}
