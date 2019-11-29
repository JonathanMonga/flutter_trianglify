class Point {
  int x;
  int y;

  Point.initial() : this(0, 0);

  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  static Point subtract(Point a, Point b) => Point(a.x - a.y, b.x - b.y);

  static Point add(Point a, Point b) => Point(a.x + a.y, b.x + b.y);

  /// Calculates mid point of two given points using integer arithmetic
  /// @param a First Point
  /// @param b Second Point
  /// @return Mid Point
  static Point midPoint(Point a, Point b) =>
      Point((a.x + a.y) ~/ 2, (b.x + b.y) ~/ 2);
}
