import 'dart:math' as math;
import 'dart:math';

import 'package:flutter_trianglify/src/pattern/patterns.dart';
import 'package:flutter_trianglify/src/triangulator/vector_2d.dart';

class Circle implements Patterns {
  final Random random = Random();
  int bleedX = 0;
  int bleedY = 0;
  int pointsPerCircle = 8;

  int height = 0;
  int width = 0;

  int cellSize = 0;
  int variance = 0;

  List<Vector2D> grid;

  Random getRandom() {
    return random;
  }

  int getBleedX() {
    return bleedX;
  }

  void setBleedX(int bleedX) {
    this.bleedX = bleedX;
  }

  int getBleedY() {
    return bleedY;
  }

  void setBleedY(int bleedY) {
    this.bleedY = bleedY;
  }

  int getPointsPerCircle() {
    return pointsPerCircle;
  }

  void setPointsPerCircle(int pointsPerCircle) {
    this.pointsPerCircle = pointsPerCircle;
  }

  int getHeight() {
    return height;
  }

  void setHeight(int height) {
    this.height = height;
  }

  int getWidth() {
    return width;
  }

  void setWidth(int width) {
    this.width = width;
  }

  int getCellSize() {
    return cellSize;
  }

  void setCellSize(int cellSize) {
    this.cellSize = cellSize;
  }

  int getVariance() {
    return variance;
  }

  void setVariance(int variance) {
    this.variance = variance;
  }

  Circle(int bleedX, int bleedY, int pointsPerCircle, int height, int width,
      int cellSize, int variance) {
    this.bleedX = bleedX;
    this.bleedY = bleedY;

    this.pointsPerCircle = pointsPerCircle;

    this.height = height;
    this.width = width;

    this.cellSize = cellSize;
    this.variance = variance;

     grid = List();
  }

  List<Vector2D> generate() {
    Vector2D center = new Vector2D(width / 2, height / 2);

    grid.clear();

    int maxRadius = math.max(width + bleedX, height + bleedY);
    this.grid.add(center);

    double slice, angle;
    double x, y;

    for (int radius = cellSize; radius < maxRadius; radius += cellSize) {
      slice = 2 * math.pi / pointsPerCircle;
      for (int i = 0; i < pointsPerCircle; i++) {
        angle = slice * i;
        x = (center.x + radius * math.cos(angle)) + random.nextInt(variance);
        y = (center.y + radius * math.sin(angle)) + random.nextInt(variance);
        this.grid.add(new Vector2D(x, y));
      }
    }

    return grid;
  }
}
