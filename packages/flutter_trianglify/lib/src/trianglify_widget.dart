// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart'
    show BuildContext, Canvas, Center, ClipRect, Color, Colors, Container, CustomPaint, CustomPainter, Offset, Paint, PaintingStyle, Path, PathFillType, Size, Widget, required;
import 'package:flutter_trianglify/src/abstract_trianglify.dart';
import 'package:flutter_trianglify/src/palette.dart';
import 'package:flutter_trianglify/src/triangulation.dart';
import 'package:flutter_trianglify/src/triangulator/triangle_2d.dart';

/// A triangle that is drawn with [CustomPainter]
class TrianglifyWidget extends AbstractTrianglify {
  /// All of the parameters are required and must not be null.
  const TrianglifyWidget(
      {@required double bleedX,
      @required double bleedY,
      @required int typeGrid,
      @required double gridWidth,
      @required double gridHeight,
      @required double variance,
      @required double cellSize,
      @required bool isFillViewCompletely,
      @required bool isFillTriangle,
      @required bool isDrawStroke,
      @required bool isRandomColoring,
      @required Palette palette,
      @required Triangulation triangulation})
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
        assert(triangulation != null),
        super(
          bleedX: bleedX,
          bleedY: bleedY,
          typeGrid: typeGrid,
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          variance: variance,
          cellSize: cellSize,
          isFillViewCompletely: isFillViewCompletely,
          isFillTriangle: isFillTriangle,
          isDrawStroke: isDrawStroke,
          isRandomColoring: isRandomColoring,
          palette: palette,
          triangulation: triangulation,
        );

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          color: Colors.white,
            width: gridWidth - 50,
            height: gridHeight - 50,
            child: ClipRect(
      child: CustomPaint(
        painter: _TrianglifyWidgetPainter(
            bleedX: 75 + bleedX,
            bleedY: 28 + bleedY ,
            typeGrid: typeGrid,
            gridWidth: gridWidth,
            gridHeight: gridHeight,
            variance: variance,
            cellSize: cellSize,
            isFillViewCompletely: isFillViewCompletely,
            isFillTriangle: isFillTriangle,
            isDrawStroke: isDrawStroke,
            isRandomColoring: isRandomColoring,
            palette: palette,
            triangulation: triangulation),
        isComplex: true,
      ),
    )));
  }
}

/// [CustomPainter] that draws a Triangles.
class _TrianglifyWidgetPainter extends CustomPainter {
  static const double BASE_SIZE = 320.0;
  static const double STROKE_WIDTH = 1.0;

  _TrianglifyWidgetPainter(
      {@required this.bleedX,
      @required this.bleedY,
      @required this.typeGrid,
      @required this.gridWidth,
      @required this.gridHeight,
      @required this.variance,
      @required this.cellSize,
      @required this.isFillViewCompletely,
      @required this.isFillTriangle,
      @required this.isDrawStroke,
      @required this.isRandomColoring,
      @required this.palette,
      @required this.triangulation})
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
        assert(triangulation != null);

  double bleedX;
  double bleedY;
  int typeGrid;
  double gridWidth;
  double gridHeight;
  double variance;
  double cellSize;
  bool isFillViewCompletely;
  bool isFillTriangle;
  bool isDrawStroke;
  bool isRandomColoring;
  Palette palette;
  Triangulation triangulation;
  bool generateOnlyColor;

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = size.shortestSide / BASE_SIZE;
    final center = (Offset.zero & size).center;
    _plotOnCanvas(canvas, center, size, scaleFactor);
  }

  @override
  bool shouldRepaint(_TrianglifyWidgetPainter oldTrianglifyPainter) {
    return oldTrianglifyPainter.bleedX != bleedX ||
        oldTrianglifyPainter.bleedY != bleedY ||
        oldTrianglifyPainter.cellSize != cellSize ||
        oldTrianglifyPainter.gridWidth != gridWidth ||
        oldTrianglifyPainter.gridHeight != gridHeight ||
        oldTrianglifyPainter.typeGrid != typeGrid ||
        oldTrianglifyPainter.isDrawStroke != isDrawStroke ||
        oldTrianglifyPainter.isFillTriangle != isFillTriangle ||
        oldTrianglifyPainter.isFillViewCompletely != isFillViewCompletely ||
        oldTrianglifyPainter.isRandomColoring != isRandomColoring ||
        oldTrianglifyPainter.palette != palette ||
        oldTrianglifyPainter.triangulation != triangulation;
  }

  void _plotOnCanvas(
      Canvas canvas, Offset center, Size size, double scaleFactor) {
    for (int i = 0; i < triangulation.getTriangleList().length - 1; i++) {
      _drawTriangle(canvas, center, size, scaleFactor,
          triangulation.getTriangleList()[i]);
    }
  }

  /// Draws triangle on the canvas object passed using the parameters of current view instance
  /// @param canvas Canvas to paint on
  /// @param triangle2D Triangle to draw on canvas
  void _drawTriangle(Canvas canvas, Offset center, Size size,
      double scaleFactor, Triangle2D triangle2D) {
    Paint paint = Paint();
    int color = triangle2D.getColor();

    ///Add 0xff000000 for alpha channel required by android.graphics.Color
    color += 0xff000000;

    paint.color = Color(color);
    paint.strokeWidth = STROKE_WIDTH;

    if (isFillTriangle && isDrawStroke) {
      paint.style = PaintingStyle.fill;
    } else if (isFillTriangle) {
      paint.style = PaintingStyle.fill;
    } else if (isDrawStroke) {
      paint.style = PaintingStyle.stroke;
    } else {
      paint.style = PaintingStyle.fill;
    }

    paint.isAntiAlias = true;

    Path path = Path();
    path.fillType = PathFillType.evenOdd;

    path.moveTo((triangle2D.a.x) - (bleedX * scaleFactor),
        (triangle2D.a.y) - (bleedY * scaleFactor));
    path.lineTo((triangle2D.b.x) - (bleedX * scaleFactor),
        (triangle2D.b.y) - (bleedY * scaleFactor));
    path.lineTo((triangle2D.c.x) - (bleedX * scaleFactor),
        (triangle2D.c.y) - bleedY * scaleFactor);
    path.lineTo((triangle2D.a.x) - (bleedX * scaleFactor),
        (triangle2D.a.y) - bleedY * scaleFactor);
    path.close();

    canvas.drawPath(path, paint);
  }
}
