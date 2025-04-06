import 'package:flutter/material.dart';


// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }


import 'package:flame/game.dart';
import 'package:space_racer/SpaceRacerGame.dart';

void main() {
  runApp(
    GameWidget(
      game: SpaceRacerGame(),
    ),
  );
}