import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with HasGameRef, CollisionCallbacks {
  final double speed = 200;

  static const enemySize = 50.0;

  Obstacle({
    super.position,
  }) : super(
          size: Vector2(128, 64),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: size.x,
      height: size.y,
    );

    // === Base Gradient Paint (Tech metal look) ===
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.grey.shade100, Colors.grey.shade700],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10)),
      bodyPaint,
    );

    // === Edge highlight on top side ===
    final topHighlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10)),
      topHighlightPaint,
    );

    // === Craters/Tech Spots ===
    final craterPaint = Paint()..color = Colors.black.withOpacity(0.25);
    final center = Offset(size.x / 2, size.y / 2);

    canvas.drawCircle(center + Offset(-50, -6), 5, craterPaint);
    canvas.drawCircle(center + Offset(0, 4), 4, craterPaint);
    canvas.drawCircle(center + Offset(50, -4), 6, craterPaint);

    // === Optional Tech Panel Line ===
    final linePaint = Paint()
      ..color = Colors.grey.shade800.withOpacity(0.3)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.x * 0.25, size.y * 0.1),
      Offset(size.x * 0.25, size.y * 0.9),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.x * 0.75, size.y * 0.1),
      Offset(size.x * 0.75, size.y * 0.9),
      linePaint,
    );

    // === Glow Outline ===
    final glowPaint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.inflate(2), Radius.circular(12)),
      glowPaint,
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
