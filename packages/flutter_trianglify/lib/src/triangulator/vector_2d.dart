import 'dart:math' as math;

/// 2D vector class implementation.
class Vector2D {
  double x;
  double y;

  /// Constructor of the 2D vector class used to create new vector instances.
  ///
  /// @param [x] The [x] coordinate of the new vector
  /// @param [y] The [y] coordinate of the new vector
  Vector2D(double x, double y) {
    this.x = x;
    this.y = y;
  }

  /// Subtracts the given vector from this.
  ///
  /// @param [vector] The vector to be subtracted from this
  /// @return A new instance holding the result of the vector subtraction
  Vector2D sub(Vector2D vector) {
    return new Vector2D(this.x - vector.x, this.y - vector.y);
  }

  /// Adds the given vector to this.
  ///
  /// @param [vector] The vector to be added to this
  /// @return A new instance holding the result of the vector addition
  Vector2D add(Vector2D vector) {
    return new Vector2D(this.x + vector.x, this.y + vector.y);
  }

  /// Multiplies this by the given scalar.
  ///
  /// @param [scalar] The scalar to be multiplied by this
  /// @return A new instance holding the result of the multiplication
  Vector2D mult(double scalar) {
    return new Vector2D(this.x * scalar, this.y * scalar);
  }

  /// Computes the magnitude or length of this.
  ///
  /// @return The magnitude of this
  double mag() {
    return math.sqrt(this.x * this.x + this.y * this.y);
  }

  /// Computes the dot product of this and the given vector.
  ///
  /// @param [vector] The vector to be multiplied by this
  /// @return A new instance holding the result of the multiplication
  double dot(Vector2D vector) {
    return this.x * vector.x + this.y * vector.y;
  }

  /// Computes the 2D pseudo cross product Dot(Perp(this), vector) of this and
  /// the given vector.
  ///
  /// @param vectorThe vector to be multiplied to the perpendicular vector of this
  /// @return A new instance holding the result of the pseudo cross product
  double cross(Vector2D vector) {
    return this.y * vector.x - this.x * vector.y;
  }

  @override
  String toString() => "Vector2D[$x, $y]";
}
