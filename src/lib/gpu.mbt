///|
pub(all) enum ShaderPrimitiveTopology {
  PointList
  LineList
  LineStrip
  TriangleList
  TriangleStrip
}

///|
fn ShaderPrimitiveTopology::default() -> ShaderPrimitiveTopology {
  LineList
}

///|
fn ShaderPrimitiveTopology::to_string(self : ShaderPrimitiveTopology) -> String {
  match self {
    PointList => "point-list"
    LineList => "line-list"
    LineStrip => "line-strip"
    TriangleList => "triangle-list"
    TriangleStrip => "triangle-strip"
  }
}

///|
/// Represents the format of vertex attributes in WebGPU shaders. Each variant
/// describes the data type, size, and normalization of vertex data.
///
/// The format strings follow the WebGPU specification naming convention:
///
/// * First part indicates the data type (`uint`, `sint`, `float`) and bit width
/// (8, 16, 32)
/// * Second part (if present) indicates the number of components (x2, x3, x4)
/// * Prefix `unorm` or `snorm` indicates normalized integer formats
/// * Special case `unorm10_10_10_2` for packed 32-bit format with normalized
/// components
///
/// Parameters:
///
/// * `Uint8x2`, `Uint8x4`: Two or four unsigned 8-bit integers
/// * `Sint8x2`, `Sint8x4`: Two or four signed 8-bit integers
/// * `Unorm8x2`, `Unorm8x4`: Two or four normalized unsigned 8-bit integers
/// * `Snorm8x2`, `Snorm8x4`: Two or four normalized signed 8-bit integers
/// * `Uint16x2`, `Uint16x4`: Two or four unsigned 16-bit integers
/// * `Sint16x2`, `Sint16x4`: Two or four signed 16-bit integers
/// * `Unorm16x2`, `Unorm16x4`: Two or four normalized unsigned 16-bit integers
/// * `Snorm16x2`, `Snorm16x4`: Two or four normalized signed 16-bit integers
/// * `Float16x2`, `Float16x4`: Two or four 16-bit floating point numbers
/// * `Float32`, `Float32x2`, `Float32x3`, `Float32x4`: One to four 32-bit
/// floating point numbers
/// * `Uint32`, `Uint32x2`, `Uint32x3`, `Uint32x4`: One to four unsigned 32-bit
/// integers
/// * `Sint32`, `Sint32x2`, `Sint32x3`, `Sint32x4`: One to four signed 32-bit
/// integers
/// * `Unorm10_10_10_2`: Packed format with three 10-bit normalized unsigned
/// integers and one 2-bit normalized unsigned integer
///
/// Example:
///
/// ```moonbit
/// test "GPUVertexFormat" {
///   let format = GPUVertexFormat::Float32x4
///   inspect!(format.to_string(), content="\"float32x4\"")
/// }
/// ```
pub(all) enum GPUVertexFormat {
  Uint8x2
  Uint8x4
  Sint8x2
  Sint8x4
  Unorm8x2
  Unorm8x4
  Snorm8x2
  Snorm8x4
  Uint16x2
  Uint16x4
  Sint16x2
  Sint16x4
  Unorm16x2
  Unorm16x4
  Snorm16x2
  Snorm16x4
  Float16x2
  Float16x4
  Float32
  Float32x2
  Float32x3
  Float32x4
  Uint32
  Uint32x2
  Uint32x3
  Uint32x4
  Sint32
  Sint32x2
  Sint32x3
  Sint32x4
  Unorm10_10_10_2
}

///|
pub fn GPUVertexFormat::to_string(self : GPUVertexFormat) -> String {
  match self {
    Uint8x2 => "uint8x2"
    Uint8x4 => "uint8x4"
    Sint8x2 => "sint8x2"
    Sint8x4 => "sint8x4"
    Unorm8x2 => "unorm8x2"
    Unorm8x4 => "unorm8x4"
    Snorm8x2 => "snorm8x2"
    Snorm8x4 => "snorm8x4"
    Uint16x2 => "uint16x2"
    Uint16x4 => "uint16x4"
    Sint16x2 => "sint16x2"
    Sint16x4 => "sint16x4"
    Unorm16x2 => "unorm16x2"
    Unorm16x4 => "unorm16x4"
    Snorm16x2 => "snorm16x2"
    Snorm16x4 => "snorm16x4"
    Float16x2 => "float16x2"
    Float16x4 => "float16x4"
    Float32 => "float32"
    Float32x2 => "float32x2"
    Float32x3 => "float32x3"
    Float32x4 => "float32x4"
    Uint32 => "uint32"
    Uint32x2 => "uint32x2"
    Uint32x3 => "uint32x3"
    Uint32x4 => "uint32x4"
    Sint32 => "sint32"
    Sint32x2 => "sint32x2"
    Sint32x3 => "sint32x3"
    Sint32x4 => "sint32x4"
    Unorm10_10_10_2 => "unorm10-10-10-2"
  }
}
