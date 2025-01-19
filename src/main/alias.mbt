///|
typealias Quaternion = @quaternion.Quaternion

///|
/// Creates an alias for the `Vertex` type from the lagopus package, providing
/// a convenient way to reference vertices in 4D space with color information.
///
/// A vertex represents a point in 4D space along with its color attributes,
/// commonly used in rendering geometric shapes and visual elements in the
/// lagopus graphics system.
///
/// Example:
///
/// ```moonbit
/// test "vertex" {
///   let v : Vertex = { position: Quaternion::new(x=1.0), color: Color::white() }
///   inspect!(v.position.x, content="1.0")
/// }
/// ```
typealias Vertex = @lagopus.Vertex

///|
/// Creates an alias for the `PolylineVertex` type from the lagopus package,
/// which represents a vertex in a polyline with additional attributes for
/// rendering.
///
/// A polyline vertex contains position, color, direction and side information,
/// commonly used in rendering line segments with width in 4D space.
///
/// Example:
///
/// ```moonbit
/// test "polyline-vertex" {
///   let vertex : PolylineVertex = {
///     position: Quaternion::new(),
///     color: Color::white(),
///     direction: Quaternion::new(x=1.0),
///     side: 0,
///   }
///   inspect!(vertex.side, content="0")
/// }
/// ```
typealias PolylineVertex = @lagopus.PolylineVertex

///|
/// Creates an alias for the `Color` type from the lagopus package, providing a
/// convenient way to work with color values in the visualization system.
///
/// A color represents an RGBA color value used for rendering geometric shapes
/// and visual elements. Each component (red, green, blue, alpha) is represented
/// as a floating-point number between 0.0 and 1.0.
///
/// Example:
///
/// ```moonbit
/// test "color" {
///   let white = Color::white()
///   let semi_transparent = Color::new(r=1.0, g=0.5, b=0.2, a=0.6)
///   inspect!(semi_transparent.a, content="0.6")
/// }
/// ```
typealias Color = @lagopus.Color
