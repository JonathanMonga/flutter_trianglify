import 'package:analog_clock/trianglify/triangulator/edge_2d.dart';
import 'package:analog_clock/trianglify/triangulator/edge_distance_pack.dart';
import 'package:analog_clock/trianglify/triangulator/triangle_2d.dart';
import 'package:analog_clock/trianglify/triangulator/vector_2d.dart';

/// Triangle soup class implementation.
class TriangleSoup {
  Set<Triangle2D> triangleSoup;

  /// Constructor of the triangle soup class used to create a new triangle soup
  /// instance.
  TriangleSoup() {
    this.triangleSoup = Set();
  }

  /// Adds a triangle to this triangle soup.
  /// @param [triangle] The triangle to be added to this triangle soup
  void add(Triangle2D triangle) {
    this.triangleSoup.add(triangle);
  }

  /// Removes a triangle from this triangle soup.
  /// @param [triangle] The triangle to be removed from this triangle soup
  void remove(Triangle2D triangle) {
    this.triangleSoup.remove(triangle);
  }

  /// Returns the triangles from this triangle soup.
  /// @return The triangles from this triangle soup
  List<Triangle2D> getTriangles() {
    return this.triangleSoup.toList();
  }

  /// Returns the triangle from this triangle soup that contains the specified
  /// point or null if no triangle from the triangle soup contains the point.
  ///
  /// @param [point] The point
  /// @return Returns the triangle from this triangle soup that contains the
  /// specified point or null
  Triangle2D findContainingTriangle(Vector2D point) {
    for (Triangle2D triangle in triangleSoup) {
      if (triangle.contains(point)) {
        return triangle;
      }
    }
    return null;
  }

  /// Returns the neighbor triangle of the specified triangle sharing the same
  /// edge as specified. If no neighbor sharing the same edge exists null is
  /// returned.
  ///
  /// @param [triangle] The triangle
  /// @param [edge] The edge
  /// @return The triangles neighbor triangle sharing the same edge or null if
  /// no triangle exists
  Triangle2D findNeighbour(Triangle2D triangle, Edge2D edge) {
    for (Triangle2D triangleFromSoup in triangleSoup) {
      if (triangleFromSoup.isNeighbour(edge) && triangleFromSoup != triangle) {
        return triangleFromSoup;
      }
    }
    return null;
  }

  /// Returns one of the possible triangles sharing the specified edge. Based
  /// on the ordering of the triangles in this triangle soup the returned
  /// triangle may differ. To find the other triangle that shares this edge use
  /// the {@link findNeighbour(Triangle2D triangle, Edge2D edge)} method.
  ///
  /// @param [edge] The edge
  /// @return Returns one triangle that shares the specified edge
  Triangle2D findOneTriangleSharing(Edge2D edge) {
    for (Triangle2D triangle in triangleSoup) {
      if (triangle.isNeighbour(edge)) {
        return triangle;
      }
    }
    return null;
  }

  /// Returns the edge from the triangle soup nearest to the specified point.
  /// @param [point] The point
  /// @return The edge from the triangle soup nearest to the specified point
  Edge2D findNearestEdge(Vector2D point) {
    List<EdgeDistancePack> edgeList = List<EdgeDistancePack>();

    for (Triangle2D triangle in triangleSoup) {
      edgeList.add(triangle.findNearestEdge(point));
    }

    List<EdgeDistancePack> edgeDistancePacks =
        List<EdgeDistancePack>(edgeList.length);
    edgeList.addAll(edgeDistancePacks);

    edgeDistancePacks.sort();

    return edgeDistancePacks[0].edge;
  }

  /// Removes all triangles from this triangle soup that contain the specified
  /// vertex.
  /// @param [vertex] The vertex
  void removeTrianglesUsing(Vector2D vertex) {
    List<Triangle2D> trianglesToBeRemoved = List<Triangle2D>();

    for (Triangle2D triangle in triangleSoup) {
      if (triangle.hasVertex(vertex)) {
        trianglesToBeRemoved.add(triangle);
      }
    }

    triangleSoup.removeAll(trianglesToBeRemoved);
  }
}
