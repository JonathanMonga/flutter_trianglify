import 'package:flutter_trianglify/src/colorizers/colorizer.dart';
import 'package:flutter_trianglify/src/extended_color.dart';
import 'package:flutter_trianglify/src/palette.dart';
import 'package:flutter_trianglify/src/point.dart';
import 'package:flutter_trianglify/src/thread_local_random.dart';
import 'package:flutter_trianglify/src/triangulation.dart';
import 'package:flutter_trianglify/src/triangulator/triangle_2d.dart';
import 'package:flutter_trianglify/src/triangulator/vector_2d.dart';

/// Fixed point colorizer contains methods that colorize triangles
/// based on the color palette provided in the constructor.
class FixedPointsColorizer implements Colorizer {
  ThreadLocalRandom random;
  Triangulation triangulation;
  Palette colorPalette;

  int gridWidth;
  int gridHeight;

  bool randomColoring = false;

  Palette getColorPalette() {
    return colorPalette;
  }

  void setColorPalette(Palette colorPalette) {
    this.colorPalette = colorPalette;
  }

  Triangulation getTriangulation() {
    return triangulation;
  }

  void setTriangulation(Triangulation triangulation) {
    this.triangulation = triangulation;
  }

  FixedPointsColorizer.fromDefault(Triangulation triangulation,
      Palette colorPalette, int gridHeight, int gridWidth)
      : this(triangulation, colorPalette, gridHeight, gridWidth, false);

  FixedPointsColorizer(Triangulation triangulation, Palette colorPalette,
      int gridHeight, int gridWidth, bool randomColoring) {
    this.randomColoring = randomColoring;
    random = ThreadLocalRandom(DateTime.now().millisecond);
    this.triangulation = triangulation;
    this.colorPalette = colorPalette;
    this.gridHeight = gridHeight;
    this.gridWidth = gridWidth;
  }

  @override
  Triangulation getColororedTriangulation() {
    if (triangulation != null) {
      for (Triangle2D triangle in triangulation.getTriangleList()) {
        triangle.setColor(getColorForPoint(triangle.getCentroid()));
      }
    } else {
      print("colorizeTriangulation: Triangulation cannot be null!");
    }
    return getTriangulation();
  }

  /// Returns color corresponding to the point passed in parameter by
  /// calculating average of specified by the palette.
  ///
  ///
  /// Relation between palette color and position on rectangle is
  /// depicted in the following figure:
  ///
  /// (c1 are corresponding int values representing color in ColorPalette)
  ///    c0              c1                c2
  ///       +-------------+--------------+
  ///       |             |              |
  ///       |     r1      |      r2      |
  ///       |             |              |
  ///    c7 +------------c8--------------+ c3
  ///       |             |              |
  ///       |     r3      |      r4      |
  ///       |             |              |
  ///       +-------------+--------------+
  ///    c6              c5                c4
  ///
  ///
  /// <b>Algorithm</b>
  /// Grid provided is divided into four regions r1 to r4. Each of the region
  /// is considered independent on calculating color for a point.
  ///
  /// Sub-rectangle in which given point lies has four vertices, denoted by
  /// Point topLeft, topRight, bottomLeft and bottomRight. Algorith then
  /// calculates weighted mean of color corresponding to vertices (seperately
  /// in x-axis and y-axis). Result of this calculation is returned as int.
  ///
  /// @param point Point to get color for
  /// @return  Color corresponding to current point

  // Sorry for such long method, here's a ASCII potato
  //          __
  //         /   \
  //        /  o  \
  //       |     o \
  //      / o      |
  //     /    o    |
  //     \______o__/
  //

  int getColorForPoint(Vector2D point) {
    if (randomColoring) {
      return colorPalette.getColor(random.nextInt(9));
    } else {
      ExtendedColor topLeftColor, topRightColor;
      ExtendedColor bottomLeftColor, bottomRightColor;

      Point topLeft, topRight;
      Point bottomLeft, bottomRight;

      // Following if..else identifies which sub-rectangle given point lies
      if (point.x < gridWidth / 2 && point.y < gridHeight / 2) {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(0));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(1));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(7));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
      } else if (point.x >= gridWidth / 2 && point.y < gridHeight / 2) {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(1));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(2));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(3));
      } else if (point.x >= gridWidth / 2 && point.y >= gridHeight / 2) {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(3));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(5));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(4));
      } else {
        topLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(7));
        topRightColor = ExtendedColor.fromPalette(colorPalette.getColor(8));
        bottomLeftColor = ExtendedColor.fromPalette(colorPalette.getColor(6));
        bottomRightColor = ExtendedColor.fromPalette(colorPalette.getColor(5));
      }

      // Calculate corners of sub rectangle in which point is identified
      topLeft = Point((point.x >= gridWidth ~/ 2) ? gridWidth ~/ 2 : 0,
          (point.y >= gridHeight ~/ 2) ? gridHeight ~/ 2 : 0);
      topRight = Point((point.x >= gridWidth ~/ 2) ? gridWidth : gridWidth ~/ 2,
          (point.y >= gridHeight ~/ 2) ? gridHeight ~/ 2 : 0);
      bottomLeft = Point((point.x >= gridWidth ~/ 2) ? gridWidth ~/ 2 : 0,
          (point.y >= gridHeight ~/ 2) ? gridHeight : gridHeight ~/ 2);
      bottomRight = Point(
          (point.x >= gridWidth ~/ 2) ? gridWidth : gridWidth ~/ 2,
          (point.y >= gridHeight ~/ 2) ? gridHeight : gridHeight ~/ 2);

      // Calculates weighted mean of colors
      ExtendedColor weightedTopColor = ExtendedColor.fromRGB(
          ((topRightColor.r * (point.x - topLeft.x) +
                  (topLeftColor.r) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))),
          ((topRightColor.g * (point.x - topLeft.x) +
                  (topLeftColor.g) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))),
          ((topRightColor.b * (point.x - topLeft.x) +
                  (topLeftColor.b) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))));
      ExtendedColor weightedBottomColor = ExtendedColor.fromRGB(
          ((bottomRightColor.r * (point.x - topLeft.x) +
                  (bottomLeftColor.r) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))),
          ((bottomRightColor.g * (point.x - topLeft.x) +
                  (bottomLeftColor.g) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))),
          ((bottomRightColor.b * (point.x - topLeft.x) +
                  (bottomLeftColor.b) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))));
      ExtendedColor weightedLeftColor = ExtendedColor.fromRGB(
          ((bottomLeftColor.r * (point.y - topLeft.y) +
                  (topLeftColor.r) * (bottomLeft.y - point.y)) ~/
              ((bottomLeft.y - topLeft.y))),
          ((bottomLeftColor.g * (point.y - topLeft.y) +
                  (topLeftColor.g) * (bottomLeft.y - point.y)) ~/
              ((bottomLeft.y - topLeft.y))),
          ((bottomLeftColor.b * (point.y - topLeft.y) +
                  (topLeftColor.b) * (bottomLeft.y - point.y)) ~/
              ((bottomLeft.y - topLeft.y))));

      ExtendedColor weightedRightColor = ExtendedColor.fromRGB(
          ((bottomRightColor.r * (point.y - topRight.y) +
                  (topRightColor.r) * (bottomRight.y - point.y)) ~/
              ((bottomRight.y - topRight.y))),
          ((bottomRightColor.g * (point.y - topRight.y) +
                  (topRightColor.g) * (bottomRight.y - point.y)) ~/
              ((bottomRight.y - topRight.y))),
          ((bottomRightColor.b * (point.y - topRight.y) +
                  (topRightColor.b) * (bottomRight.y - point.y)) ~/
              ((bottomRight.y - topRight.y))));

      ExtendedColor weightedYColor = ExtendedColor.fromRGB(
          ((weightedRightColor.r * (point.x - topLeft.x) +
                  (weightedLeftColor.r) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))),
          ((weightedRightColor.g * (point.x - topLeft.x) +
                  (weightedLeftColor.g) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))),
          ((weightedRightColor.b * (point.x - topLeft.x) +
                  (weightedLeftColor.b) * (topRight.x - point.x)) ~/
              ((topRight.x - topLeft.x))));

      ExtendedColor weightedXColor = ExtendedColor.fromRGB(
          ((weightedBottomColor.r * (point.y - topLeft.y) +
                  (weightedTopColor.r) * (bottomLeft.y - point.y)) ~/
              ((bottomLeft.y - topLeft.y))),
          ((weightedBottomColor.g * (point.y - topLeft.y) +
                  (weightedTopColor.g) * (bottomLeft.y - point.y)) ~/
              ((bottomLeft.y - topLeft.y))),
          ((weightedBottomColor.b * (point.y - topLeft.y) +
                  (weightedTopColor.b) * (bottomLeft.y - point.y)) ~/
              ((bottomLeft.y - topLeft.y))));

      return ExtendedColor.avg(weightedXColor, weightedYColor).toInt();
    }
  }

  /// Calculates average of given numbers without using floating point
  /// operations
  /// @param args Values to calculate average of
  /// @return  Average of values provided
  int avg(List<int> args) {
    int sum = 0;
    for (int arg in args) {
      sum += arg;
    }
    return sum ~/ args.length;
  }
}
