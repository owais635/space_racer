import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/scheduler.dart';
import "package:space_racer/actors/Player.dart";

import 'package:flame/game.dart';
import 'package:space_racer/actors/Obstacle.dart';
import 'package:space_racer/controls/PlayerShootButton.dart';
import 'package:space_racer/controls/PlayerHorizontalControlButton.dart';

class SpaceRacerGame extends FlameGame with HasCollisionDetection {
  late Player player;
  int moveDirection = 0; // -1 = left, 1 = right, 0 = idle

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

    add(
      SpawnComponent(
        factory: (index) {
          return Obstacle();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -Obstacle.enemySize),
      ),
    );
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
