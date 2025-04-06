import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:space_racer/actors/Bullet.dart';

class Player extends PositionComponent with HasGameRef {
  static final _paint = Paint()..color = Colors.white;
  int currentLane = 1; // Start in center lane
  late final SpawnComponent _bulletSpawner;

  @override
  Future<void> onLoad() async {
    // Loading animation omitted

    _bulletSpawner = SpawnComponent(
      period: .2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position +
              Vector2(
                0,
                -height / 2,
              ),
        );
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);
  }

  @override
  void render(Canvas canvas) {
    // --- Ship Body ---
    final shipPath = Path()
      ..moveTo(size.x / 2, 0) // Tip (nose)
      ..lineTo(0, size.y * 0.4) // Left wing start
      ..lineTo(size.x * 0.25, size.y) // Bottom left
      ..lineTo(size.x * 0.75, size.y) // Bottom right
      ..lineTo(size.x, size.y * 0.4) // Right wing start
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blueGrey.shade200, Colors.grey.shade900],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    canvas.drawPath(shipPath, bodyPaint);

    // --- Cockpit ---
    final cockpitPaint = Paint()..color = Colors.cyanAccent;
    final cockpitRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y * 0.45),
      width: size.x * 0.25,
      height: size.y * 0.2,
    );
    canvas.drawOval(cockpitRect, cockpitPaint);

    // --- Engine Flare ---
    final flarePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.orangeAccent.withOpacity(0.8), Colors.transparent],
      ).createShader(Rect.fromCircle(
        center: Offset(size.x / 2, size.y + 5),
        radius: 12,
      ));

    canvas.drawCircle(Offset(size.x / 2, size.y + 5), 12, flarePaint);
  }

  @override
  void onMount() {
    size = Vector2(60, 80);
    anchor = Anchor.center;

    // Set initial position to center lane
    position = Vector2(lanePositions[currentLane], gameRef.size.y / 2);

    super.onMount();
  }

  void shoot() {
    print("Shooting");
    // _bulletSpawner.timer.start();

    final bullet = Bullet(
      position: position + Vector2(0, -height / 2), // spawn from top center
    );
    gameRef.add(bullet);
  }

  void moveLeft() {
    if (currentLane > 0) {
      currentLane--;
      updatePlayerPosition();
    }
  }

  void moveRight() {
    if (currentLane < lanePositions.length - 1) {
      currentLane++;
      updatePlayerPosition();
    }
  }

  void updatePlayerPosition() {
    final targetX = lanePositions[currentLane];
    add(
      MoveToEffect(
        Vector2(targetX, position.y),
        EffectController(duration: 0.2),
      ),
    );
  }

  List<double> get lanePositions {
    final screenWidth = gameRef.size.x;
    final edgeOffset =
        screenWidth * 0.15; // or tweak this value manually (e.g. 80)

    return [
      edgeOffset, // Left lane closer to edge
      screenWidth / 2, // Center lane
      screenWidth - edgeOffset, // Right lane closer to right edge
    ];
  }
}
