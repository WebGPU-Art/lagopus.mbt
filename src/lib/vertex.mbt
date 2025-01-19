///|
pub(all) struct Vertex {
  position : @quaternion.Quaternion
  color : Color
}

///|
pub fn Vertex::attrs() -> Array[LagopusAttribute] {
  [
    { field: "position", format: Float32x4 },
    { field: "color", format: Float32x4 },
  ]
}

///|
pub fn Vertex::to_value(
  self : Vertex
) -> @moonbitlang/core/hashmap.T[String, Array[Float]] {
  let dict : @moonbitlang/core/hashmap.T[String, Array[Float]] = @moonbitlang/core/hashmap.new()
  dict["position"] = [
    self.position.x,
    self.position.y,
    self.position.z,
    self.position.w,
  ]
  dict["color"] = [self.color.r, self.color.g, self.color.b, self.color.a]
  dict
}

///|
/// Represents a vertex in a polyline with position, color, direction, and side
/// information. Used for rendering thick lines with proper width and direction.
///
/// Fields:
///
/// * `position` : The position of the vertex in 3D space represented as a
/// quaternion.
/// * `color` : The color of the vertex.
/// * `direction` : The direction vector of the line segment at this vertex,
/// represented as a quaternion.
/// * `side` : An integer flag indicating which side of the line this vertex
/// represents (0 for left side, 1 for right side).
///
/// Example:
///
/// ```moonbit
/// test "PolylineVertex" {
///   let vertex = PolylineVertex::{
///     position: @quaternion.new(1.0, 0.0, 0.0, 1.0),
///     color: Color::red(),
///     direction: @quaternion.new(0.0, 1.0, 0.0, 0.0),
///     side: 0,
///   }
///   inspect!(vertex.side, content="0")
/// }
/// ```
pub(all) struct PolylineVertex {
  position : @quaternion.Quaternion
  color : Color
  direction : @quaternion.Quaternion
  side : Int
}

///|
/// Converts a `PolylineVertex` instance into a hashmap representation suitable
/// for WebGPU vertex buffer data. The resulting hashmap contains the vertex's
/// position, color, direction, and side information as arrays of floating-point
/// numbers.
///
/// Parameters:
///
/// * `self` : The `PolylineVertex` instance to convert.
///
/// Returns a hashmap with the following key-value pairs:
///
/// * `"position"` : Array of 4 floats representing the vertex position as XYZW
/// coordinates
/// * `"color"` : Array of 4 floats representing RGBA color components
/// * `"direction"` : Array of 4 floats representing the direction vector as XYZW
/// coordinates
/// * `"side"` : Single-element array containing the side flag as a float
///
/// Example:
///
/// ```moonbit
/// test "PolylineVertex::to_value" {
///   let vertex = PolylineVertex::{
///     position: @quaternion.new(1.0, 0.0, 0.0, 1.0),
///     color: Color::red(),
///     direction: @quaternion.new(0.0, 1.0, 0.0, 0.0),
///     side: 0,
///   }
///   let dict = vertex.to_value()
///   inspect!(dict["position"], content="[1.0, 0.0, 0.0, 1.0]")
///   inspect!(dict["color"], content="[1.0, 0.0, 0.0, 1.0]")
/// }
/// ```
pub fn PolylineVertex::to_value(
  self : PolylineVertex
) -> @moonbitlang/core/hashmap.T[String, Array[Float]] {
  let dict : @moonbitlang/core/hashmap.T[String, Array[Float]] = @moonbitlang/core/hashmap.new()
  dict["position"] = self.position.to_xyzw()
  dict["color"] = [self.color.r, self.color.g, self.color.b, self.color.a]
  dict["direction"] = self.direction.to_xyzw()
  dict["side"] = [self.side.to_float()] // need int but JavaScript auto converts
  dict
}

///|
/// Returns an array of vertex attributes required for rendering a polyline
/// vertex in WebGPU.
///
/// Returns an array of `LagopusAttribute` containing the following vertex
/// attributes:
///
/// * `position`: A 4D float vector (x, y, z, w) representing the vertex position
/// * `color`: A 4D float vector (r, g, b, a) representing the vertex color
/// * `direction`: A 4D float vector representing the direction of the line
/// segment
/// * `side`: A 32-bit signed integer indicating which side of the line this
/// vertex represents (0 for left, 1 for right)
///
/// Example:
///
/// ```moonbit
/// test "PolylineVertex::attrs" {
///   let attrs = PolylineVertex::attrs()
///   inspect!(attrs.length(), content="4")
///   inspect!(attrs[0].field, content="\"position\"")
///   inspect!(attrs[0].format, content="Float32x4")
/// }
/// ```
pub fn PolylineVertex::attrs() -> Array[LagopusAttribute] {
  [
    { field: "position", format: Float32x4 },
    { field: "color", format: Float32x4 },
    { field: "direction", format: Float32x4 },
    { field: "side", format: Sint32 },
  ]
}

///|
/// Represents an error that can occur during vertex data building process.
///
/// Returns a new error type that wraps a string message.
///
/// Example:
///
/// ```moonbit
/// test "BuilderError" {
///   let err = BuilderError("chunk size must be at least 2")
///   inspect!(err, content="BuilderError(\"chunk size must be at least 2\")")
/// }
/// ```
pub(all) type! BuilderError String derive(Show)

///| turn a chunk of vertices into triangles data
pub fn create_vertex_data(
  chunk : Array[Vertex],
  width? : Float
) -> Array[PolylineVertex]!BuilderError {
  let data = []
  let size = chunk.length()
  if size < 2 {
    raise BuilderError("chunk size must be at least 2")
  }
  for i = 0; i < size - 1; i = i + 1 {
    let vertex = chunk[i]
    let vertex_next = chunk[i + 1]
    let direction = (vertex_next.position - vertex.position)
      .normalize()
      .scale(width.or(2.0))
    /// 2 triangles
    data.push(PolylineVertex::{
      position: vertex.position,
      color: vertex.color,
      direction,
      side: 0,
    })
    data.push(PolylineVertex::{
      position: vertex_next.position,
      color: vertex_next.color,
      direction,
      side: 0,
    })
    data.push(PolylineVertex::{
      position: vertex.position,
      color: vertex.color,
      direction,
      side: 1,
    })
    data.push(PolylineVertex::{
      position: vertex.position,
      color: vertex.color,
      direction,
      side: 1,
    })
    data.push(PolylineVertex::{
      position: vertex_next.position,
      color: vertex_next.color,
      direction,
      side: 1,
    })
    data.push(PolylineVertex::{
      position: vertex_next.position,
      color: vertex_next.color,
      direction,
      side: 0,
    })
  }
  data
}
