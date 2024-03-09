// import 'dart:async';
//
// import 'package:astro_guardian/game/game_service_impl.dart';
// import 'package:astro_guardian/game/util/lerp.dart';
// import 'package:astro_guardian/game_hud/game_hud.dart';
// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
//
// class HudMapCameraBagIndicatorComponent extends PositionComponent with HasGameRef<GameHudComponent> {
//   final CameraComponent cameraComponent;
//
//   HudMapCameraBagIndicatorComponent({
//     required this.cameraComponent,
//   });
//
//   Vector2 _pos = Vector2.zero();
//
//   @override
//   FutureOr<void> onLoad() {
//     anchor = Anchor.center;
//     return super.onLoad();
//   }
//
//   @override
//   void update(double dt) {
//     _updateVisibility(dt);
//     _updatePosition();
//     super.update(dt);
//   }
//
//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//
//     final bagComponent = game.gameComponent.world.shipComponent.bagComponent;
//     if (bagComponent == null) return;
//
//     final rect = Rect.fromLTWH(
//       0.0,
//       0.0,
//       size.x,
//       size.y,
//     );
//
//     final p = game.gameComponent.game.ship.bagPercentage.clamp(0.0, 1.0);
//     final color = ColorTween(
//       begin: Colors.green.shade500,
//       end: Colors.red.shade600,
//     ).lerp(p);
//
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         rect,
//         Radius.circular(size.x * 0.2),
//       ),
//       Paint()..color = (color ?? Colors.white).withOpacity(_opacity),
//     );
//
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         rect,
//         Radius.circular(size.x * 0.2),
//       ),
//       Paint()
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = size.x * 0.15
//         ..color = Colors.white.withOpacity(_opacity),
//     );
//   }
//
//   double _opacity = 0.0;
//
//   _updateVisibility(double dt) {
//     final visible = _calculateBagIndicatorVisibility();
//
//     _opacity = LerpUtils.d(
//       dt,
//       target: visible ? 1.0 : 0.0,
//       value: _opacity,
//       time: 1.0,
//     ).clamp(0.0, 1.0);
//
//     scale = Vector2.all(LerpUtils.d(
//       dt,
//       target: visible ? 1.5 : 1.0,
//       value: scale.x,
//       time: 1.0,
//     ))
//       ..clamp(Vector2.zero(), Vector2.all(9999));
//   }
//
//   _updatePosition() {
//     final pos = _bagIndicatorPosition;
//     if (pos != null) _pos = pos;
//     position = _pos;
//     size = Vector2.all(cameraComponent.viewport.size.x * 0.1);
//     final bagComponent = game.gameComponent.world.shipComponent.bagComponent;
//     angle = bagComponent?.angle ?? 0.0;
//   }
//
//   Vector2? get _bagIndicatorPosition {
//     final shipComponent = game.gameComponent.world.shipComponent;
//     final c = shipComponent.bagComponent;
//     if (c == null) return null;
//     final projection = cameraComponent.localToGlobal(c.body.position);
//     final p = projection - cameraComponent.viewport.position;
//
//     p.clamp(
//       Vector2.zero(),
//       cameraComponent.viewport.size,
//     );
//
//     return p;
//   }
//
//   bool _calculateBagIndicatorVisibility() {
//     final p = _bagIndicatorPosition;
//     if (p == null) return false;
//
//     final s = cameraComponent.viewport.size;
//     if (p.x > 0 && p.x < s.x && p.y > 0 && p.y < s.y) return false;
//
//     return true;
//   }
// }
