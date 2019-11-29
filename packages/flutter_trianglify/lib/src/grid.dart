import 'package:flutter_trianglify/src/triangulator/vector_2d.dart';

class Grid {
  List<Vector2D> gridPoints;

  Grid(List<Vector2D> gridPoints) {
    this.gridPoints = gridPoints;
  }

  List<Vector2D> getGridPoints() {
    return gridPoints;
  }
}
