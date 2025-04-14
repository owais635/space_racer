import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class PlayerShootButton extends HudButtonComponent {
  final TextComponent _ammoText;

  PlayerShootButton({
    required Vector2 position,
    required VoidCallback onPressed,
    required VoidCallback onReleased,
    required double width,
    required int initialAmmo,
  })  : _ammoText = TextComponent(
          text: '$initialAmmo',
          anchor: Anchor.center,
          position: Vector2(width / 2, 45),
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                )
              ],
            ),
          ),
        ),
        super(
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
                    package: Icons.whatshot.fontPackage,
                    color: Colors.white,
                  ),
                ),
                anchor: Anchor.center,
                position: Vector2(width / 2, 25),
              ),
            ],
          ),
          onPressed: onPressed,
          onReleased: onReleased,
          priority: 10,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Safe to access button now
    button?.add(_ammoText);
  }

  /// Update ammo text
  void updateAmmo(int ammo) {
    _ammoText.text = '$ammo';
  }

  /// Update + pulse if low
  void pulseAmmoIfLow(int ammo) {
    updateAmmo(ammo);

    if (ammo <= 3) {
      _ammoText.add(
        ScaleEffect.by(
          Vector2.all(1.3),
          EffectController(
            duration: 0.1,
            reverseDuration: 0.1,
            alternate: true,
          ),
        ),
      );

      _ammoText.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.8),
              offset: Offset(0, 1),
              blurRadius: 2,
            )
          ],
        ),
      );
    } else {
      _ammoText.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.8),
              offset: Offset(0, 1),
              blurRadius: 2,
            )
          ],
        ),
      );
    }
  }
}
