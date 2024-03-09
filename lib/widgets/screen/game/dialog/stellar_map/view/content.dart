import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/base_overlay.dart';
import 'package:astro_guardian/widgets/common/game_title/game_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:repository/repository.dart';
import 'package:touchable/touchable.dart';

import 'painter.dart';

class GameDialogStellarMapContent extends StatefulHookWidget {
  final GameComponent game;
  final Animation<double> animation;

  const GameDialogStellarMapContent({
    super.key,
    required this.game,
    required this.animation,
  });

  @override
  State<GameDialogStellarMapContent> createState() => _GameDialogStellarMapContentState();
}

class _GameDialogStellarMapContentState extends State<GameDialogStellarMapContent> {
  PlanetSummaryRepository get _planetSummaryRepository => GetIt.I.get();
  final _transformationController = TransformationController();
  double _scale = 1.0;
  PlanetSummary? _planetSummary;

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.paddingOf(context);

    final points = useMemoized(
      () {
        if (_planetSummary == null) return <Offset>[];
        return _planetSummary?.planets.map((e) => Offset(e.position.x, e.position.y)).toList() ?? <Offset>[];
      },
      [_planetSummary],
    );

    return GameBaseOverlay(
      game: widget.game,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              InteractiveViewer(
                maxScale: 200,
                transformationController: _transformationController,
                onInteractionUpdate: (details) {
                  final currentScale = _transformationController.value.getMaxScaleOnAxis();
                  _scale = currentScale;
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(
                    left: p.left + 32 * 4,
                    top: 32 * 4,
                    right: p.right + 32 * 4,
                    bottom: p.bottom + 32 * 4,
                  ),
                  child: CanvasTouchDetector(
                    gesturesToOverride: const [GestureType.onTapUp],
                    builder: (context) => CustomPaint(
                      painter: MapPainter(
                        context: context,
                        game: widget.game,
                        points: _planetSummary?.planets ?? [],
                        zoomScale: _scale,
                        shipPosition: Offset(
                          widget.game.world.shipComponent.position.x,
                          widget.game.world.shipComponent.position.y,
                        ),
                      ),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: p.top + 16,
                left: p.left + 16,
                right: p.right + 16,
                child: GameTitle(
                  title: "Stellar map ${_planetSummary?.planets.length}",
                  closeButtonVisible: true,
                  onCloseButtonPressed: () => Navigator.of(context).maybePop(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _init());
  }

  _init() async {
    final summary = await _planetSummaryRepository.get(widget.game.game.uid);
    setState(() => _planetSummary = summary);
  }
}
