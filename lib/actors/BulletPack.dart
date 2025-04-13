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
    final cellWidth = size.x / 5;
    final bulletHeight = size.y * 0.6;
    final capHeight = size.y * 0.4;

    final bulletPaint = Paint()..color = const Color(0xFF8B6F37); // casing
    final capPaint = Paint()..color = const Color(0xFFFFF176); // yellow tip
    final capEdgePaint = Paint()
      ..color = const Color(0xFFD84315); // red/orange edge
    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final x = i * cellWidth;

      // bullet casing
      final casingRect = Rect.fromLTWH(x, capHeight, cellWidth, bulletHeight);
      canvas.drawRect(casingRect, bulletPaint);
      canvas.drawRect(casingRect, borderPaint);

      // bullet cap
      final capRect = Rect.fromLTWH(x, 0, cellWidth, capHeight);
      canvas.drawRect(capRect, capPaint);

      // left edge for detail
      final edgeRect = Rect.fromLTWH(x, 0, cellWidth * 0.1, capHeight);
      canvas.drawRect(edgeRect, capEdgePaint);
    }

    // Optional: bottom base line
    final basePaint = Paint()..color = Colors.black.withOpacity(0.2);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 2, size.x, 2),
      basePaint,
    );
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
