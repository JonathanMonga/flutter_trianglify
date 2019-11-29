import 'package:flutter_trianglify/src/pattern/patterns.dart';
import 'package:flutter_trianglify/src/thread_local_random.dart';
import 'package:flutter_trianglify/src/triangulator/vector_2d.dart';

class Rectangle implements Patterns {
  ThreadLocalRandom random;
  int bleedX = 0;
  int bleedY = 0;

  int height = 0;
  int width = 0;

  int cellSize = 0;
  int variance = 0;

  List<Vector2D> grid;

  Rectangle(int bleedX, int bleedY, int height, int width, int cellSize,
      int variance) {
    this.bleedX = bleedX;
    this.bleedY = bleedY;

    this.variance = variance;
    this.cellSize = cellSize;

    this.height = height;
    this.width = width;

    random = ThreadLocalRandom();

    grid = List();
  }

  /// Generates array of points arranged in a grid of rectangles with deviation from their positions
  /// on the basis of bleed value.
  /// @return List of Vector2D containing points that resembles rectangular grid
  @override
  List<Vector2D> generate() {
    grid.clear();

    int x, y;
    for (int j = 0; j < height + 2 * bleedY; j += cellSize) {
      for (int i = 0; i < width + 2 * bleedX; i += cellSize) {
        x = i + random.nextInt(variance);
        y = j + random.nextInt(variance);
        this.grid.add(Vector2D(x.toDouble(), y.toDouble()));
      }
    }

    return grid;
  }
}
