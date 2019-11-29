// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:analog_clock/trianglify/palette.dart';
import 'package:analog_clock/trianglify/triangulation.dart';
import 'package:flutter/material.dart';

/// A base class for an trianglify-drawing widget.
abstract class AbstractTrianglify extends StatelessWidget {
  /// Create a const [AbstractTrianglify].
  ///
  /// All of the parameters are required and must not be null.
  const AbstractTrianglify({
    @required this.bleedX,
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
    @required this.triangulation,
  })  : assert(bleedX != null),
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
        assert(triangulation != null),
        assert(palette != null);

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
}
