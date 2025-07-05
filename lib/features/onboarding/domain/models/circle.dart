import 'dart:math';
import 'dart:ui';

class Circle {
  Circle({
    required this.center,
    required this.direction,
  });

  Offset center;
  Offset direction;

  late double radius = sqrt(
    pow((center.dx - direction.dx), 2) + pow((center.dy - direction.dy), 2),
  );

  double getDistance(Offset point) => sqrt(
        pow((center.dx - point.dx), 2) + pow((center.dy - point.dy), 2),
      );
}
