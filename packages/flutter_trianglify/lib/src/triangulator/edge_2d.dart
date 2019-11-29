
import 'package:analog_clock/trianglify/triangulator/vector_2d.dart';

/// 2D edge class implementation.
class Edge2D {

    Vector2D a;
    Vector2D b;

    /// Constructor of the 2D edge class used to create a new edge instance from
    /// two 2D vectors describing the edge's vertices.
    /// 
    /// @param [a]The first vertex of the edge
    /// @param [b]The second vertex of the edge
    Edge2D(Vector2D a, Vector2D b) {
        this.a = a;
        this.b = b;
    }

}