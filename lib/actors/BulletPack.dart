import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BulletPack extends PositionComponent with HasGameRef, CollisionCallbacks {
  final double speed;

  BulletPack({super.position, this.speed = 200})
      : super(
          size: Vector2(128, 64),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RectangleHitbox(collisionType: CollisionType.passive));

    size = Vector2(50, 40); // Matches the pixel ratio
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final outlineColor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final bulletColor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: size.x,
      height: size.y,
    );

    // Draw outline box (like all buttons in the reference image)
    final border = RRect.fromRectAndRadius(rect, Radius.circular(4));
    canvas.drawRRect(border, outlineColor);

    // Draw bullets inside (you can tweak spacing/count)
    const int bulletCount = 3;
    final bulletWidth = size.x / (bulletCount * 2);
    final bulletHeight = size.y * 0.5;

    for (int i = 0; i < bulletCount; i++) {
      final x = size.x * 0.2 + i * bulletWidth * 2;
      final bulletRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, size.y * 0.25, bulletWidth, bulletHeight),
        topLeft: Radius.circular(2),
        topRight: Radius.circular(2),
      );

      canvas.drawRRect(bulletRect, bulletColor);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y - size.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
