import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_racer/SpaceRacerGame.dart';
import 'dart:math';

import 'package:space_racer/actors/Obstacle.dart';

class Bullet extends PositionComponent
    with HasGameReference<SpaceRacerGame>, CollisionCallbacks {
  // static final _paint = Paint()..color = Colors.white;

// @override
// void render(Canvas canvas) {
//   final path = Path()
//     ..moveTo(size.x / 2, 0)               // Tip of the bullet
//     ..lineTo(0, size.y * 0.3)             // Upper left taper
//     ..lineTo(size.x * 0.2, size.y)        // Lower left corner
//     ..lineTo(size.x * 0.8, size.y)        // Lower right corner
//     ..lineTo(size.x, size.y * 0.3)        // Upper right taper
//     ..close();                            // Back to tip

//   final paint = Paint()
//     ..shader = const LinearGradient(
//       colors: [Colors.orange, Colors.yellow],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     ).createShader(Rect.fromLTWH(0, 0, size.x, size.y))
//     ..style = PaintingStyle.fill;

//   canvas.drawPath(path, paint);
// }

  Bullet({
    super.position,
  }) : super(
          size: Vector2(25, 50),
          anchor: Anchor.center,
        );

  late final Paint _paint;

  // Bullet({required Vector2 position}) {
  // this.position = position;
  // size = Vector2(10, 30);
  // anchor = Anchor.center;

  // final random = Random();

  // // Generate two random bright colors for a gradient
  // final color1 = HSVColor.fromAHSV(
  //   1.0,
  //   random.nextDouble() * 360,
  //   0.8,
  //   1.0,
  // ).toColor();

  // final color2 = HSVColor.fromAHSV(
  //   1.0,
  //   random.nextDouble() * 360,
  //   0.8,
  //   1.0,
  // ).toColor();

  // _paint = Paint()
  //   ..shader = LinearGradient(
  //     colors: [color1, color2],
  //     begin: Alignment.topCenter,
  //     end: Alignment.bottomCenter,
  //   ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
  // }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    this.position = position;
    size = Vector2(10, 30);
    anchor = Anchor.center;

    final random = Random();

    // Generate two random bright colors for a gradient
    final color1 = HSVColor.fromAHSV(
      1.0,
      random.nextDouble() * 360,
      0.8,
      1.0,
    ).toColor();

    final color2 = HSVColor.fromAHSV(
      1.0,
      random.nextDouble() * 360,
      0.8,
      1.0,
    ).toColor();

    _paint = Paint()
      ..shader = LinearGradient(
        colors: [color1, color2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    add(
      RectangleHitbox(
        collisionType: CollisionType.active,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..moveTo(size.x / 2, 0) // Tip
      ..lineTo(0, size.y * 0.3) // Left taper
      ..lineTo(size.x * 0.2, size.y) // Bottom left
      ..lineTo(size.x * 0.8, size.y) // Bottom right
      ..lineTo(size.x, size.y * 0.3) // Right taper
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500;

    if (position.y < -height) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Obstacle) {
      removeFromParent();
      other.removeFromParent();
    }
  }
}
