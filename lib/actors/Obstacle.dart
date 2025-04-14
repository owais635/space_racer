import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with HasGameRef, CollisionCallbacks {
  final double speed;
  final List<Offset> _craterPositions = [];
  final List<Offset> _asteroidPoints = [];

  static const enemySize = 50.0;

  Obstacle({super.position, this.speed = 200})
      : super(
          size: Vector2(64, 64),
          anchor: Anchor.center,
        ) {
    final rng = Random();

    // === Craters ===
    final craterCount = rng.nextInt(3) + 2;
    for (int i = 0; i < craterCount; i++) {
      final dx = rng.nextDouble() * (size.x - 12) + 6;
      final dy = rng.nextDouble() * (size.y - 12) + 6;
      _craterPositions.add(Offset(dx, dy));
    }

    // === Irregular polygon points (like classic asteroid) ===
    final segments = 8;
    final radius = size.x / 2;
    for (int i = 0; i < segments; i++) {
      final angle = (2 * pi / segments) * i;
      final r = radius * (0.8 + rng.nextDouble() * 0.4); // jaggedness
      final x = size.x / 2 + cos(angle) * r;
      final y = size.y / 2 + sin(angle) * r;
      _asteroidPoints.add(Offset(x, y));
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    final outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final craterPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // === Draw jagged asteroid outline ===
    final path = Path()..addPolygon(_asteroidPoints, true);
    canvas.drawPath(path, outlinePaint);

    // === Draw craters ===
    for (final pos in _craterPositions) {
      canvas.drawCircle(pos, 3, craterPaint);
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
