import 'package:flutter_trianglify/src/triangulator/triangle_2d.dart';

class Triangulation {
  List<Triangle2D> triangleList;

  Triangulation(List<Triangle2D> triangleList) {
    this.triangleList = triangleList;
  }

  List<Triangle2D> getTriangleList() {
    return triangleList;
  }
}
