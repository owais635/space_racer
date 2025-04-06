import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class PlayerShootButton extends HudButtonComponent{
  PlayerShootButton({
    required Vector2 position,
    required VoidCallback onPressed,
    required VoidCallback onReleased,
    required double width,
  }) : super(
          position: position,
          size: Vector2(width, 60),
          button: RectangleComponent(
            paint: Paint()..color = Colors.grey.withOpacity(0.6),
            size: Vector2(width, 60),
            children: [
              TextComponent(
                text: String.fromCharCode(Icons.whatshot.codePoint),
                textRenderer: TextPaint(
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: Icons.whatshot.fontFamily,
                    package: Icons
                        .whatshot.fontPackage, // Optional but recommended
                  ),
                ),
                anchor: Anchor.center,
                position: Vector2(30, 30),
              ),
            ],
          ),
          onPressed: onPressed,
          onReleased: onReleased,
          priority: 10

        );


 
}
