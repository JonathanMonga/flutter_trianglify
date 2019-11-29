import 'package:analog_clock/trianglify/triangulator/edge_2d.dart';
import 'package:analog_clock/trianglify/triangulator/triangle_2d.dart'
    show Triangle2D;
import 'package:analog_clock/trianglify/triangulator/triangle_soup.dart'
    show TriangleSoup;
import 'package:analog_clock/trianglify/triangulator/vector_2d.dart'
    show Vector2D;

import 'dart:math' as math;

/// A Dart implementation of an incremental 2D Delaunay triangulation algorithm.
class DelaunayTriangulator {
  List<Vector2D> pointSet;
  TriangleSoup triangleSoup;

  /// Constructor of the SimpleDelaunayTriangulator class used to create a   /// triangulator instance.
  /// @param [pointSet] The point set to be triangulated
  /// @throws Exception Thrown when the point set contains less than three points
  DelaunayTriangulator(List<Vector2D> pointSet) {
    this.pointSet = pointSet;
    this.triangleSoup = TriangleSoup();
  }

  /// This method generates a Delaunay triangulation from the specified point set.
  /// @throws com.sdsmdg.kd.trianglify.utilities.triangulator.NotEnoughPointsException
  void triangulate() {
    triangleSoup = TriangleSoup();

    if (pointSet == null || pointSet.length < 3) {
      throw Exception("Less than three points in point set.");
    }

    ///In order for the in circumcircle test to not consider the vertices of
    /// the super triangle we have to start out with a big triangle
    /// containing the whole point set. We have to scale the super triangle
    /// to be very large. Otherwise the triangulation is not convex.
    double maxOfAnyCoordinate = 0.0;

    for (Vector2D vector in getPointSet()) {
      maxOfAnyCoordinate =
          math.max(math.max(vector.x, vector.y), maxOfAnyCoordinate);
    }

    maxOfAnyCoordinate *= 16.0;

    double newCoordinate = 3.0 * maxOfAnyCoordinate;
    final Vector2D p1 = Vector2D(0.0, newCoordinate);
    final Vector2D p2 = Vector2D(newCoordinate, 0.0);
    final Vector2D p3 = Vector2D(-newCoordinate, -newCoordinate);

    final Triangle2D superTriangle = Triangle2D(p1, p2, p3);

    triangleSoup.add(superTriangle);

    for (int i = 0; i < pointSet.length - 1; i++) {
      Triangle2D triangle = triangleSoup.findContainingTriangle(pointSet[i]);

      if (triangle == null) {
        /// If no containing triangle exists, then the vertex is not
        /// inside a triangle (this can also happen due to numerical
        /// errors) and lies on an edge. In order to find this edge we
        /// search all edges of the triangle soup and select the one
        /// which is nearest to the point we try to add. This edge is
        /// removed and four edges are added.
        final Edge2D edge = triangleSoup.findNearestEdge(pointSet[i]);

        final Triangle2D first = triangleSoup.findOneTriangleSharing(edge);
        final Triangle2D second = triangleSoup.findNeighbour(first, edge);

        final Vector2D firstNoneEdgeVertex = first.getNoneEdgeVertex(edge);
        final Vector2D secondNoneEdgeVertex = second.getNoneEdgeVertex(edge);

        triangleSoup.remove(first);
        triangleSoup.remove(second);

        final Triangle2D triangle1 =
            Triangle2D(edge.a, firstNoneEdgeVertex, pointSet[i]);
        final Triangle2D triangle2 =
            Triangle2D(edge.b, firstNoneEdgeVertex, pointSet[i]);
        final Triangle2D triangle3 =
            Triangle2D(edge.a, secondNoneEdgeVertex, pointSet[i]);
        final Triangle2D triangle4 =
            Triangle2D(edge.b, secondNoneEdgeVertex, pointSet[i]);

        triangleSoup.add(triangle1);
        triangleSoup.add(triangle2);
        triangleSoup.add(triangle3);
        triangleSoup.add(triangle4);

        legalizeEdge(
            triangle1, Edge2D(edge.a, firstNoneEdgeVertex), pointSet[i]);
        legalizeEdge(
            triangle2, Edge2D(edge.b, firstNoneEdgeVertex), pointSet[i]);
        legalizeEdge(
            triangle3, Edge2D(edge.a, secondNoneEdgeVertex), pointSet[i]);
        legalizeEdge(
            triangle4, Edge2D(edge.b, secondNoneEdgeVertex), pointSet[i]);
      } else {
        /// The vertex is inside a triangle.
        final Vector2D a = triangle.a;
        final Vector2D b = triangle.b;
        final Vector2D c = triangle.c;

        triangleSoup.remove(triangle);

        final Triangle2D first = Triangle2D(a, b, pointSet[i]);
        final Triangle2D second = Triangle2D(b, c, pointSet[i]);
        final Triangle2D third = Triangle2D(c, a, pointSet[i]);

        triangleSoup.add(first);
        triangleSoup.add(second);
        triangleSoup.add(third);

        legalizeEdge(first, Edge2D(a, b), pointSet[i]);
        legalizeEdge(second, Edge2D(b, c), pointSet[i]);
        legalizeEdge(third, Edge2D(c, a), pointSet[i]);
      }
    }

    /// Remove all triangles that contain vertices of the super triangle.
    triangleSoup.removeTrianglesUsing(superTriangle.a);
    triangleSoup.removeTrianglesUsing(superTriangle.b);
    triangleSoup.removeTrianglesUsing(superTriangle.c);
  }

  /// This method legalizes edges by recursively flipping all illegal edges.
  /// @param [triangle] The triangle
  /// @param [edge] The edge to be legalized
  /// @param [newVertex] The vertex
  void legalizeEdge(Triangle2D triangle, Edge2D edge, Vector2D newVertex) {
    final Triangle2D neighbourTriangle =
        triangleSoup.findNeighbour(triangle, edge);

    /// If the triangle has a neighbor, then legalize the edge
    if (neighbourTriangle != null) {
      if (neighbourTriangle.isPointInCircumcircle(newVertex)) {
        triangleSoup.remove(triangle);
        triangleSoup.remove(neighbourTriangle);

        final Vector2D noneEdgeVertex =
            neighbourTriangle.getNoneEdgeVertex(edge);

        final Triangle2D firstTriangle =
            Triangle2D(noneEdgeVertex, edge.a, newVertex);
        final Triangle2D secondTriangle =
            Triangle2D(noneEdgeVertex, edge.b, newVertex);

        triangleSoup.add(firstTriangle);
        triangleSoup.add(secondTriangle);

        legalizeEdge(
            firstTriangle, Edge2D(noneEdgeVertex, edge.a), newVertex);
        legalizeEdge(
            secondTriangle, Edge2D(noneEdgeVertex, edge.b), newVertex);
      }
    }
  }

  /// Creates a random permutation of the specified point set. Based on the
  /// implementation of the Delaunay algorithm this can speed up the
  /// computation.
  void shuffle() {
    pointSet.shuffle();
  }

  /// Shuffles the point set using a custom permutation sequence.
  /// @param [permutation] The permutation used to shuffle the point set
  void shuffleThePointSet(List<int> permutation) {
    List<Vector2D> temp = List<Vector2D>();
    for (int i = 0; i < permutation.length; i++) {
      temp.add(pointSet[permutation[i]]);
    }
    pointSet = temp;
  }

  /// Returns the point set in form of a vector of 2D vectors.
  /// @return Returns the points set.
  List<Vector2D> getPointSet() => pointSet;

  /// Returns the trianges of the triangulation in form of a vector of 2D
  /// triangles.
  /// @return Returns the triangles of the triangulation.
  List<Triangle2D> getTriangles() => triangleSoup.getTriangles();
}
