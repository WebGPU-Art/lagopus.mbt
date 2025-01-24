///|
pub(all) struct Vertex {
  position : V3
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
  dict["position"] = [self.position.x, self.position.y, self.position.z]
  dict["color"] = [self.color.r, self.color.g, self.color.b, self.color.a]
  dict
}

///|
/// Represents a vertex in a polyline with position, color, direction, and side
/// information. Used for rendering thick lines with proper width and direction.
pub(all) struct PolylineVertex {
  position : V3
  brush : UInt
  direction : V3
  width : Float
  mark : Float
}

///|
/// Converts a `PolylineVertex` instance into a hashmap representation suitable
/// for WebGPU vertex buffer data. The resulting hashmap contains the vertex's
/// position, color, direction, and side information as arrays of floating-point
/// numbers.
pub fn PolylineVertex::to_value(
  self : PolylineVertex
) -> @moonbitlang/core/hashmap.T[String, Array[Float]] {
  let dict : @moonbitlang/core/hashmap.T[String, Array[Float]] = @moonbitlang/core/hashmap.new()
  dict["position"] = self.position.to_array()
  dict["brush"] = [self.brush.to_float()] // need int but JavaScript auto converts
  dict["direction"] = self.direction.to_array()
  dict["width"] = [self.width]
  dict["mark"] = [self.mark]
  dict
}

///|
/// Returns an array of vertex attributes required for rendering a polyline
/// vertex in WebGPU.
pub fn PolylineVertex::attrs() -> Array[LagopusAttribute] {
  [
    { field: "position", format: Float32x3 },
    { field: "brush", format: Uint32 },
    { field: "direction", format: Float32x3 },
    { field: "width", format: Float32 },
    { field: "mark", format: Float32 },
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
  let width = width.or(2.0)
  for i = 0; i < size - 1; i = i + 1 {
    let vertex = chunk[i]
    let vertex_next = chunk[i + 1]
    let direction = vertex_next.position - vertex.position
    let direction_next = if i + 2 < size {
      chunk[i + 2].position - vertex_next.position
    } else {
      direction
    }
    /// 2 triangles
    data.push(PolylineVertex::{
      position: vertex.position,
      brush: 0,
      direction,
      width,
      mark: 0,
    })
    data.push(PolylineVertex::{
      position: vertex_next.position,
      brush: 0,
      direction: direction_next,
      width,
      mark: 0,
    })
    data.push(PolylineVertex::{
      position: vertex.position,
      brush: 1,
      direction,
      width,
      mark: 0,
    })
    data.push(PolylineVertex::{
      position: vertex.position,
      brush: 1,
      direction,
      width,
      mark: 0,
    })
    data.push(PolylineVertex::{
      position: vertex_next.position,
      brush: 1,
      direction: direction_next,
      width,
      mark: 0,
    })
    data.push(PolylineVertex::{
      position: vertex_next.position,
      brush: 0,
      direction: direction_next,
      width,
      mark: 0,
    })
  }
  data
}
