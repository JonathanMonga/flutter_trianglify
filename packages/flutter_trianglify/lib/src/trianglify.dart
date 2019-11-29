import 'package:flutter/material.dart';
import 'package:flutter_trianglify/src/colorizers/colorizer.dart';
import 'package:flutter_trianglify/src/colorizers/fixed_points_colorizer.dart';
import 'package:flutter_trianglify/src/palette.dart';
import 'package:flutter_trianglify/src/pattern/circle.dart';
import 'package:flutter_trianglify/src/pattern/patterns.dart';
import 'package:flutter_trianglify/src/pattern/rectangle.dart';
import 'package:flutter_trianglify/src/trianglify_widget.dart';
import 'package:flutter_trianglify/src/triangulation.dart';
import 'package:flutter_trianglify/src/triangulator/delaunay_triangulator.dart';
import 'package:flutter_trianglify/src/triangulator/vector_2d.dart';

class Trianglify extends StatelessWidget {
  static const int GRID_RECTANGLE = 0;
  static const int GRID_CIRCLE = 1;

  final double bleedX;
  final double bleedY;
  final int typeGrid;
  final double gridWidth;
  final double gridHeight;
  final double variance;
  final double cellSize;
  final bool isFillViewCompletely;
  final bool isFillTriangle;
  final bool isDrawStroke;
  final bool isRandomColoring;
  final Palette palette;
  final Triangulation triangulation;
  final bool generateOnlyColor;

  const Trianglify(
      {Key key,
      this.bleedX,
      this.bleedY,
      this.typeGrid,
      this.gridWidth,
      this.gridHeight,
      this.variance,
      this.cellSize,
      this.isFillViewCompletely,
      this.isFillTriangle,
      this.isDrawStroke,
      this.isRandomColoring,
      this.palette,
      this.triangulation,
      this.generateOnlyColor})
      : assert(bleedX != null),
        assert(bleedY != null),
        assert(typeGrid != null),
        assert(gridWidth != null),
        assert(gridHeight != null),
        assert(variance != null),
        assert(cellSize != null),
        assert(isFillViewCompletely != null),
        assert(isFillTriangle != null),
        assert(isDrawStroke != null),
        assert(isRandomColoring != null),
        assert(palette != null),
        assert(bleedY <= cellSize || bleedX <= cellSize),
        super(key: key);

  /// generateAndInvalidate method is called when the triangulation is to be generated from scratch. It sets the
  /// GenerateOnlyColor boolean of presenter to false so that when generateSoupAndInvalidateView is
  /// called, the grid and delaunay triangulation is regenerated according to the new parameters, followed by
  /// colorization and plotting of the triangulation onto the view.

  Future<Triangulation> _generate() async => _getSoup();

  /// Generates soup corresponding to current instance parameters
  /// @return triangulation generated
  Future<Triangulation> _getSoup() async {
    if (this.generateOnlyColor) {
      return _generateColoredSoup(_generateSoup());
    } else {
      return _generateSoup();
    }
  }

  /// Generates colored triangulation.
  Triangulation _generateSoup() =>
      _generateColoredSoup(_generateTriangulation(_generateGrid()));

  /// Creates triangles from a list of points
  /// @param inputGrid Grid of points for generating triangles
  /// @return List of Triangles generated from list of input points
  Triangulation _generateTriangulation(List<Vector2D> inputGrid) {
    DelaunayTriangulator triangulator = DelaunayTriangulator(inputGrid);
    try {
      triangulator.triangulate();
    } on Exception {
      print("Error on generateTriangulation");
    }

    return Triangulation(triangulator.getTriangles());
  }

  /// Colors each triangle in triangulation and stores color as triangle's color variable
  /// @param inputTriangulation triangulation to color
  /// @return Colored triangulation of input triangulation
  Triangulation _generateColoredSoup(Triangulation inputTriangulation) {
    Colorizer colorizer = FixedPointsColorizer(
        inputTriangulation,
        this.palette,
        (this.gridHeight + 2 * this.bleedY).toInt(),
        (this.gridWidth + 2 * this.bleedX).toInt(),
        this.isRandomColoring);
    return colorizer.getColororedTriangulation();
  }

  /// Generates a grid on basis of selected grid type
  /// @return Grid of Vector2D
  List<Vector2D> _generateGrid() {
    int gridType = this.typeGrid;
    Patterns patterns;

    switch (gridType) {
      case GRID_RECTANGLE:
        patterns = Rectangle(
            this.bleedX.toInt(),
            this.bleedY.toInt(),
            this.gridHeight.toInt(),
            this.gridWidth.toInt(),
            this.cellSize.toInt(),
            this.variance.toInt());
        break;
      case GRID_CIRCLE:
        patterns = Circle(
            this.bleedX.toInt(),
            this.bleedY.toInt(),
            8,
            this.gridHeight.toInt(),
            this.gridWidth.toInt(),
            this.cellSize.toInt(),
            this.variance.toInt());
        break;
      default:
        patterns = Rectangle(
            this.bleedX.toInt(),
            this.bleedY.toInt(),
            this.gridHeight.toInt(),
            this.gridWidth.toInt(),
            this.cellSize.toInt(),
            this.variance.toInt());
        break;
    }
    
    return patterns.generate();
  }

  @override
  Widget build(BuildContext context) {
    if (triangulation == null) {
      return FutureBuilder(
        future: _generate(),
        builder: (BuildContext context, AsyncSnapshot<Triangulation> snapshot) {
          if (snapshot.hasData) {
            return TrianglifyWidget(
              bleedX: this.bleedX,
              bleedY: this.bleedY,
              cellSize: this.cellSize,
              gridWidth: this.gridWidth,
              gridHeight: this.gridHeight,
              isDrawStroke: this.isDrawStroke,
              isFillTriangle: this.isFillTriangle,
              isFillViewCompletely: this.isFillViewCompletely,
              isRandomColoring: this.isRandomColoring,
              typeGrid: this.typeGrid,
              variance: this.variance,
              palette: this.palette,
              triangulation: snapshot.data,
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return TrianglifyWidget(
        bleedX: this.bleedX,
        bleedY: this.bleedY,
        cellSize: this.cellSize,
        gridWidth: this.gridWidth,
        gridHeight: this.gridHeight,
        isDrawStroke: this.isDrawStroke,
        isFillTriangle: this.isFillTriangle,
        isFillViewCompletely: this.isFillViewCompletely,
        isRandomColoring: this.isRandomColoring,
        typeGrid: this.typeGrid,
        variance: this.variance,
        palette: this.palette,
        triangulation: this.triangulation,
      );
    }
  }
}
