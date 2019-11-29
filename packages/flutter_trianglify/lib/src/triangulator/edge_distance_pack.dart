import 'package:analog_clock/trianglify/triangulator/edge_2d.dart';

/// Edge distance pack class implementation used to describe the distance to a
/// given edge.
class EdgeDistancePack implements Comparable<EdgeDistancePack> {
  Edge2D edge;
  double distance;

  /// Constructor of the edge distance pack class used to create a new edge
  /// distance pack instance from a 2D edge and a scalar value describing a
  /// distance.
  ///
  /// @param [edge] The edge
  /// @param [distance] The distance of the edge to some point
  EdgeDistancePack(Edge2D edge, double distance) {
    this.edge = edge;
    this.distance = distance;
  }

  @override
  int compareTo(EdgeDistancePack o) {
    return this.distance.compareTo(o.distance);
  }
}
