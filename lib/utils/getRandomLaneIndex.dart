import 'dart:math';

int getRandomLaneIndex(int max, Set<int>? numbersToAvoid) {
  // Choose a lane index that is not the same as the last one
  int laneIndex;
  do {
    laneIndex = Random().nextInt(max);
  } while (numbersToAvoid != null && numbersToAvoid.contains(laneIndex));

  return laneIndex;
}
