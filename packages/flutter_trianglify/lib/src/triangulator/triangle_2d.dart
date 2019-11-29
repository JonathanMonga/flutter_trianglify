import 'package:analog_clock/trianglify/triangulator/edge_2d.dart';
import 'package:analog_clock/trianglify/triangulator/edge_distance_pack.dart';
import 'package:analog_clock/trianglify/triangulator/vector_2d.dart';

///2D triangle class implementation.
class Triangle2D {
  Vector2D a;
  Vector2D b;
  Vector2D c;
  int color;

  /// Constructor of the 2D triangle class used to create a triangle
  /// instance from three 2D vectors describing the triangle's vertices.
  ///
  /// @param [a]The first vertex of the triangle
  /// @param [b] The second vertex of the triangle
  /// @param [c]The third vertex of the triangle
  Triangle2D(Vector2D a, Vector2D b, Vector2D c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }

  /// Tests if a 2D point lies inside this 2D triangle. See Real-Time Collision
  /// Detection, chap. 5, p. 206.
  ///
  /// @param [point]The point to be tested
  /// @return Returns true iff the point lies inside this 2D triangle
  bool contains(Vector2D point) {
    final double pab = point.sub(a).cross(b.sub(a));
    final double pbc = point.sub(b).cross(c.sub(b));

    if (!hasSameSign(pab, pbc)) {
      return false;
    }

    double pca = point.sub(c).cross(a.sub(c));

    if (!hasSameSign(pab, pca)) {
      return false;
    }

    return true;
  }

  /// Tests if a given point lies in the circumcircle of this triangle. Let the
  /// triangle ABC appear in counterclockwise (CCW) order. Then when det &gt;
  /// 0, the point lies inside the circumcircle through the three points a, b
  /// and c. If instead det &lt; 0, the point lies outside the circumcircle.
  /// When det = 0, the four points are cocircular. If the triangle is oriented
  /// clockwise (CW) the result is reversed. See Real-Time Collision Detection,
  /// chap. 3, p. 34.
  ///
  /// @param [point] The point to be tested
  /// @return Returns true iff the point lies inside the circumcircle through
  /// the three points a, b, and c of the triangle
  bool isPointInCircumcircle(Vector2D point) {
    final double a11 = a.x - point.x;
    final double a21 = b.x - point.x;
    final double a31 = c.x - point.x;

    final double a12 = a.y - point.y;
    final double a22 = b.y - point.y;
    final double a32 = c.y - point.y;

    final double a13 =
        (a.x - point.x) * (a.x - point.x) + (a.y - point.y) * (a.y - point.y);
    final double a23 =
        (b.x - point.x) * (b.x - point.x) + (b.y - point.y) * (b.y - point.y);
    final double a33 =
        (c.x - point.x) * (c.x - point.x) + (c.y - point.y) * (c.y - point.y);

    final double det = a11 * a22 * a33 +
        a12 * a23 * a31 +
        a13 * a21 * a32 -
        a13 * a22 * a31 -
        a12 * a21 * a33 -
        a11 * a23 * a32;

    if (isOrientedCCW()) {
      return det > 0.0;
    }

    return det < 0.0;
  }

  /// Test if this triangle is oriented counterclockwise (CCW). Let A, B and C
  /// be three 2D points. If det &gt; 0, C lies to the left of the directed
  /// line AB. Equivalently the triangle ABC is oriented counterclockwise. When
  /// det &lt; 0, C lies to the right of the directed line AB, and the triangle
  /// ABC is oriented clockwise. When det = 0, the three points are colinear.
  /// See Real-Time Collision Detection, chap. 3, p. 32
  ///
  /// @return Returns true iff the triangle ABC is oriented counterclockwise CCW)
  bool isOrientedCCW() {
    final double a11 = a.x - c.x;
    final double a21 = b.x - c.x;

    final double a12 = a.y - c.y;
    final double a22 = b.y - c.y;

    final double det = a11 * a22 - a12 * a21;

    return det > 0.0;
  }

  /// Returns true if this triangle contains the given edge.
  ///
  /// @param [edge] The edge to be tested
  /// @return Returns true if this triangle contains the edge
  bool isNeighbour(Edge2D edge) {
    return (a == edge.a || b == edge.a || c == edge.a) &&
        (a == edge.b || b == edge.b || c == edge.b);
  }

  /// Returns the vertex of this triangle that is not part of the given edge.
  ///
  /// @param [edge] The edge
  /// @return The vertex of this triangle that is not part of the edge
  Vector2D getNoneEdgeVertex(Edge2D edge) {
    if (a != edge.a && a != edge.b) {
      return a;
    } else if (b != edge.a && b != edge.b) {
      return b;
    } else if (c != edge.a && c != edge.b) {
      return c;
    }

    return null;
  }

  /// Returns true if the given vertex is one of the vertices describing this
  /// triangle.
  ///
  /// @param [vertex] The vertex to be tested
  /// @return Returns true if the Vertex is one of the vertices describing this triangle
  bool hasVertex(Vector2D vertex) {
    if (a == vertex || b == vertex || c == vertex) {
      return true;
    }

    return false;
  }

  /// Returns an EdgeDistancePack containing the edge and its distance nearest
  /// to the specified point.
  ///
  /// @param [point] The point the nearest edge is queried for
  /// @return The edge of this triangle that is nearest to the specified point
  EdgeDistancePack findNearestEdge(Vector2D point) {
    List<EdgeDistancePack> edges = List<EdgeDistancePack>(3);

    edges[0] = EdgeDistancePack(Edge2D(a, b),
        computeClosestPoint(Edge2D(a, b), point).sub(point).mag());
    edges[1] = EdgeDistancePack(Edge2D(b, c),
        computeClosestPoint(Edge2D(b, c), point).sub(point).mag());
    edges[2] = EdgeDistancePack(Edge2D(c, a),
        computeClosestPoint(Edge2D(c, a), point).sub(point).mag());

    edges.sort();

    return edges[0];
  }

  /// Computes the closest point on the given edge to the specified point.
  ///
  /// @param [edge] The edge on which we search the closest point to the specified point
  /// @param [point] The point to which we search the closest point on the edge
  /// @return The closest point on the given edge to the specified point
  Vector2D computeClosestPoint(Edge2D edge, Vector2D point) {
    final Vector2D ab = edge.b.sub(edge.a);
    double t = point.sub(edge.a).dot(ab) / ab.dot(ab);

    if (t < 0.0) {
      t = 0.0;
    } else if (t > 1.0) {
      t = 1.0;
    }

    return edge.a.add(ab.mult(t));
  }

  /// Tests if the two arguments have the same sign.
  ///
  /// @param [a] The first floating point argument
  /// @param [b] The second floating point argument
  /// @return Returns true iff both arguments have the same sign
  bool hasSameSign(double a, double b) {
    return a.sign == b.sign;
  }

  void setColor(int color) {
    this.color = color;
  }

  int getColor() {
    return color;
  }

  @override
  String toString() => "Triangle2D[$a, $b, $c]";

  Vector2D getCentroid() {
    Vector2D centroid = Vector2D(0, 0);
    centroid.x = ((a.x) + (b.x) + (c.x)) / 3;
    centroid.y = ((a.y) + (b.y) + (c.y)) / 3;
    return centroid;
  }
}
