import 'package:flutter/material.dart';

class PuzzleCell {
  late int value;
  late int dx;
  late int dy;
  late Color color;
  late Image image;

  PuzzleCell({
    required this.value,
    required this.dx,
    required this.dy,
    required this.color,
    required this.image,
  });

  FractionalOffset get alignment {
    return FractionalOffset(dx / 2, dy / 2);
  }

  @override
  String toString() {
    return 'PuzzleCell{value: $value, dx: $dx, dy: $dy, color: $color}';
  }
}
