import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_racer/actors/BulletPack.dart';
import "package:space_racer/actors/Player.dart";

import 'package:flame/game.dart';
import 'package:space_racer/actors/Obstacle.dart';
import 'package:space_racer/controls/PlayerShootButton.dart';
import 'package:space_racer/controls/PlayerHorizontalControlButton.dart';
import 'package:space_racer/utils/getRandomLaneIndex.dart';

const double bulletPackChance = 0.11;

class SpaceRacerGame extends FlameGame with HasCollisionDetection {
  late Player player;
  int moveDirection = 0; // -1 = left, 1 = right, 0 = idle

  double distanceSinceLastSpawn = 0;
  double minGap = 200; // pixel gap between obstacles

  double difficultyLevel = 1.0;
  double difficultyTimer = 0.0;
  int? lastLaneIndex;

  late TextComponent difficultyText;

  @override
  void update(double dt) {
    super.update(dt);

    final fallSpeed = 200 + (difficultyLevel * 50);

    // Update difficulty every few seconds
    difficultyTimer += dt;

    difficultyText.text = 'Difficulty: ${difficultyLevel.toStringAsFixed(1)}';

    if (difficultyTimer > 5) {
      difficultyTimer = 0;
      difficultyLevel += 0.2;
    }

    // Increase distance based on how far obstacles fall
    distanceSinceLastSpawn += fallSpeed * dt;

    // Spawn if we've "moved" far enough
    if (distanceSinceLastSpawn >= minGap) {
      spawnObstacle(fallSpeed);

      if (bulletPackChance > Random().nextDouble()) {
        spawnBulletPack(fallSpeed, lastLaneIndex!);
      }

      distanceSinceLastSpawn = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.y - 200),
      Offset(size.x, size.y - 200),
      paint,
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player();

    addControlButtons();

    add(
      player
        // ..position = (size / 2) + Vector2(0, 100)
        ..position = size - Vector2(0, 100)
        ..width = 50
        ..height = 100
        ..anchor = Anchor.center,
    );

    add(
      Obstacle(position: Vector2.all(100))
        // ..position = (size / 2) + Vector2(0, 100)
        ..position = Vector2.all(size.x / 2)
        ..anchor = Anchor.center,
    );

    // add(
    //   SpawnComponent(
    //     factory: (index) {
    //       return Obstacle();
    //     },
    //     period: 1,
    //     area: Rectangle.fromLTWH(0, 0, size.x, -Obstacle.enemySize),
    //   ),
    // );

    difficultyText = TextComponent(
      text: 'Difficulty: ${difficultyLevel}',
      position: Vector2(size.x - 130, 100), // top-right corner
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      priority: 100, // make sure it stays on top
    );

    add(difficultyText);
  }

  void spawnObstacle(double speed) {
    final lanes = player.lanePositions;

    // Choose a lane index that is not the same as the last one
    int bulletLaneIndex = getRandomLaneIndex(
        lanes.length, lastLaneIndex != null ? <int>{lastLaneIndex!} : <int>{});

    lastLaneIndex = bulletLaneIndex; // remember this spawn

    final bulletXPos = lanes[bulletLaneIndex];

    add(Obstacle(
      position: Vector2(bulletXPos, -60),
      speed: speed,
    ));
  }

  void spawnBulletPack(double speed, int bulletLaneIndex) {
    final lanes = player.lanePositions;

    // Choose a lane index that is not the same as the last one
    int bulletPackLaneIndex =
        getRandomLaneIndex(lanes.length, <int>{bulletLaneIndex});

    final bulletPackXPos = lanes[bulletPackLaneIndex];

    add(BulletPack(
      position: Vector2(bulletPackXPos, -60),
      speed: speed,
    ));
  }

  void addControlButtons() {
    /** ============= BOTTOM CONTROL BUTTONS =========== */

    const totalFlex = 3; // Total flex units
    const spacing = 20.0; // spacing between buttons

    final usableWidth = size.x - (4 * spacing); // 4 spacings for 3 buttons

    final leftWidth = (1 / totalFlex) * usableWidth; // flex 1
    final shootWidth = (1 / totalFlex) * usableWidth;
    final rightWidth = (1 / totalFlex) * usableWidth;

    final controlButtonYPos = size.y - 128;

    double xCursor = spacing;

    add(PlayerHorizontalControlButton(
        type: PlayerControlButton.left,
        position: Vector2(xCursor, controlButtonYPos),
        onPressed: () => player.moveLeft(),
        onReleased: () => moveDirection = 0,
        width: leftWidth));
    xCursor += leftWidth + spacing;

    add(PlayerShootButton(
      position: Vector2(xCursor, controlButtonYPos),
      onPressed: () => player.shoot(),
      onReleased: () => moveDirection = 0,
      width: shootWidth,
    ));
    xCursor += shootWidth + spacing;

    add(PlayerHorizontalControlButton(
        type: PlayerControlButton.right,
        position: Vector2(xCursor, controlButtonYPos),
        onPressed: () => player.moveRight(),
        onReleased: () => moveDirection = 0,
        width: rightWidth));
  }
}
