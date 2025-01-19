///|
pub extern "js" fn initialize_context() -> Promise =
  #| () => Lagopus.initializeContext()

///|
/// Triggers a redraw of the current Lagopus render tree. Updates the WebGPU
/// canvas with the latest state of all render objects in the scene graph.
pub extern "js" fn paint_lagopus_tree() -> Unit =
  #| () => Lagopus.paintLagopusTree()

///|
pub extern "js" fn render_lagopus_tree(
  el : LagopusRenderObject,
  dispatch : () -> Unit
) -> Unit =
  #| (el, dispatch) => Lagopus.renderLagopusTree(el, dispatch)

///|
/// Adjusts the canvas size to match its display size, ensuring proper rendering
/// and preventing scaling artifacts.
///
/// Parameters:
///
/// * `canvas` : The HTML canvas element to be resized. Must be a valid DOM
/// Element object obtained through methods like `Document::query_selector`.
pub extern "js" fn reset_canvas_size(canvas : Element) -> Unit =
  #| (canvas) => Lagopus.resetCanvasSize(canvas)

///|
/// Initializes textures required for WebGPU rendering on the canvas. Sets up
/// necessary texture configurations and bindings for the rendering pipeline.
pub extern "js" fn initialize_canvas_textures() -> Unit =
  #| () => Lagopus.initializeCanvasTextures()

///|
pub extern "js" fn setup_mouse_events() -> Unit =
  #| () => Lagopus.setupMouseEvents()

///|
/// Sets up gamepad input handling for WebGPU rendering. Initializes event
/// listeners and state management for gamepad connections, button presses, and
/// axis movements. Enables real-time input detection from connected gamepads to
/// control the WebGPU rendering viewport and scene.
pub extern "js" fn load_gamepad_control() -> Unit =
  #| () => Lagopus.loadGamepadControl()

///| need a better name from Lagopus
pub extern "js" fn lines_wgsl() -> String =
  #| () => Lagopus.triangleWgsl

///|
/// Returns the WebGPU Shader Language (WGSL) code used for rendering polylines
/// in Lagopus. The shader includes vertex and fragment stages necessary for
/// drawing thick lines with proper width and direction handling.
///
/// Returns a string containing the WGSL shader code for polyline rendering.
pub extern "js" fn polyline_wgsl() -> String =
  #| () => Lagopus.polylineWgsl

///|
/// Connects a retained atom to browser's localStorage for persistent state
/// management. The connection can be configured to enable/disable reading from
/// or writing to localStorage.
///
/// Parameters:
///
/// * `name` : A unique identifier string for the retained atom. This name is
/// used as the key in localStorage.
/// * `read` : Optional boolean flag to control loading from localStorage.
/// Defaults to `true`. When set to `false`, disables loading stored values.
/// * `write` : Optional boolean flag to control saving to localStorage. Defaults
/// to `true`. When set to `false`, disables saving values.
///
/// Example:
///
/// ```moonbit
/// test "connect_retained_atom_to_srorage" {
///   connect_retained_atom_to_srorage("read-only-state", read=true, write=true)
/// }
/// ```
pub fn connect_retained_atom_to_srorage(
  name : String,
  /// false to disable loading from localStorage
  read? : Bool,
  /// false to disable saving to localStorage
  write? : Bool
) -> Unit {
  lagopus_connect_retained_atom_to_srorage(name, read.or(true), write.or(true))
}

///| get viewer states saved in localStorage so that it can be restored
extern "js" fn lagopus_connect_retained_atom_to_srorage(
  name : String,
  read : Bool,
  write : Bool
) -> Unit =
  #| (name, read, write) => Lagopus.connectRetainedAtomToStorage(name, {read, write})

///|
/// Represents the vertex data used in Lagopus rendering objects. Provides two
/// variants for different rendering approaches:
/// basic vertices for simple shapes and polyline vertices for thick lines with
/// proper width handling.
///
/// Parameters:
///
/// For `WithPoints`:
///
/// * `vertices` : An array of basic vertices, each containing position and color
/// information.
///
/// For `WithTriangles`:
///
/// * `vertices` : An array of polyline vertices, each containing position,
/// color, direction, and side information for thick line rendering.
///
/// Example:
///
/// ```moonbit
/// test "ObjectData" {
///   let points = ObjectData::WithPoints([
///     Vertex::{
///       position: @quaternion.new(0.0, 0.0, 0.0, 1.0),
///       color: Color::red(),
///     },
///   ])
///   match points {
///     WithPoints(vertices) => inspect!(vertices.length(), content="1")
///     WithTriangles(_) => inspect!(false, content="true")
///   }
/// }
/// ```
pub(all) enum ObjectData {
  WithPoints(Array[Vertex])
  WithTriangles(Array[PolylineVertex])
}

///|
fn ObjectData::to_data(
  self : ObjectData
) -> Array[@hashmap.T[String, Array[Float]]] {
  match self {
    ObjectData::WithPoints(data) => {
      let ret = []
      for vertex in data {
        ret.push(vertex.to_value())
      }
      ret
    }
    ObjectData::WithTriangles(data) => {
      let ret = []
      for vertex in data {
        ret.push(vertex.to_value())
      }
      ret
    }
  }
}

///|
/// Represents configuration options for creating a WebGPU render object in
/// Lagopus. Contains essential information about the rendering pipeline,
/// including shader configuration, vertex data, and rendering topology.
///
/// Fields:
///
/// * `label` : A string identifier for the render object, useful for debugging
/// purposes.
/// * `shader` : The WebGPU shader code as a string, defining how vertices should
/// be processed and rendered.
/// * `topology` : The primitive topology type that determines how vertices are
/// interpreted (e.g., point list, line list, triangle list).
/// * `data` : The vertex data to be rendered, can be either basic vertices or
/// polyline vertices with additional attributes.
/// * `indices` : Optional array of unsigned integers specifying the vertex
/// indices for indexed rendering.
/// * `get_params` : Optional callback function that returns an array of
/// floating-point values used as shader parameters.
///
/// Example:
///
/// ```moonbit
/// test "LagopusObjectOptions" {
///   let options = LagopusObjectOptions::{
///     label: "triangle",
///     shader: @lagopus.lines_wgsl(),
///     topology: ShaderPrimitiveTopology::TriangleList,
///     data: ObjectData::WithPoints([]),
///     indices: None,
///     get_params: None,
///   }
///   inspect!(options.label, content="\"triangle\"")
///   inspect!(options.topology, content="TriangleList")
/// }
/// ```
pub(all) struct LagopusObjectOptions {
  label : String
  shader : String
  topology : ShaderPrimitiveTopology
  data : ObjectData
  indices : Array[UInt]?
  get_params : (() -> Array[Float])?
}

///|
fn LagopusObjectOptions::as_value(self : LagopusObjectOptions) -> JsValue {
  let obj = JsObject::new()
  obj.set("label", JsValue::from_string(self.label))
  obj.set("shader", JsValue::from_string(self.shader))
  obj.set("topology", JsValue::from_string(self.topology.to_string()))
  let attrs_list = JsArray::new()
  let attrs = match self.data {
    WithPoints(_) => Vertex::attrs()
    WithTriangles(_) => PolylineVertex::attrs()
  }
  for attr in attrs {
    attrs_list.push(attr.as_value())
  }
  obj.set("attrsList", attrs_list.as_value())
  let data = JsArray::new()
  for val in self.data.to_data() {
    let obj = JsObject::new()
    for key, value in val {
      let arr = JsArray::new()
      for v in value {
        arr.push(JsValue::from_number(v))
      }
      obj.set(key, JsValue::from_array(arr))
    }
    data.push(JsValue::from_object(obj))
  }
  obj.set("data", data.as_value())
  // indices
  let get_params = fn() -> JsValue {
    match self.get_params {
      Some(f) =>
        JsValue::from_fn(fn() {
          let ret = f()
          let arr = JsArray::new()
          for val in ret {
            arr.push(JsValue::from_number(val))
          }
          arr.as_value()
        })
      None => JsValue::from_bool(false)
    }
  }
  obj.set("getParams", JsValue::from_fn(get_params))
  obj.as_value()
}

///| Converts the vertex format to its WebGPU string representation.
/// These strings match the format names in the WebGPU specification.
/// See: https://www.w3.org/TR/webgpu/#vertex-formats
pub(all) struct LagopusAttribute {
  field : String
  format : GPUVertexFormat
}

///|
fn LagopusAttribute::as_value(self : LagopusAttribute) -> JsValue {
  let obj = JsObject::new()
  obj.set("field", JsValue::from_string(self.field))
  obj.set("format", JsValue::from_string(self.format.to_string()))
  JsObject::as_value(obj)
}

///|
type LagopusRenderObject

///| Creates a new Lagopus render object with the specified configuration
extern "js" fn LagopusRenderObject::as_value(
  self : LagopusRenderObject
) -> JsValue =
  #| (self) => self

///|
/// Creates a new WebGPU render object in the Lagopus rendering system with
/// specified vertex data and rendering configuration.
///
/// Parameters:
///
/// * `data` : The vertex data to be rendered. Can be either basic vertices
/// (`WithPoints`) or polyline vertices (`WithTriangles`) with additional
/// attributes for thick line rendering.
/// * `shader` : Optional WebGPU shader code as a string. If not provided,
/// automatically selects an appropriate shader based on the vertex data type
/// (`lines_wgsl` for `WithPoints`, `polyline_wgsl` for `WithTriangles`).
/// * `label` : Optional string identifier for the render object, useful for
/// debugging. Defaults to "object".
/// * `topology` : Optional primitive topology type that determines how vertices
/// are interpreted (e.g., point list, line list). Defaults to `TriangleList`.
/// * `get_params` : Optional callback function that returns an array of
/// floating-point values used as shader parameters.
/// * `indices` : Optional array of unsigned integers specifying the vertex
/// indices for indexed rendering.
///
/// Returns a new `LagopusRenderObject` that can be used in the Lagopus
/// rendering system.
///
/// Example:
///
/// ```moonbit
/// test "object/basic" {
///   let vertices = [
///     Vertex::{
///       position: @quaternion.new(0.0, 0.0, 0.0, 1.0),
///       color: Color::red(),
///     },
///   ]
///   let triangle = object(data=ObjectData::WithPoints(vertices))
///   inspect!(triangle, content="[object Object]")
/// }
/// ```
pub fn object(
  data~ : ObjectData,
  /// by default, pick the shader based on the data type
  shader? : String,
  /// default to "object"
  label? : String,
  /// default to TriangleList
  topology? : ShaderPrimitiveTopology,
  /// default to None
  get_params? : (() -> Array[Float])?,
  /// default to None
  indices? : Array[UInt]?
) -> LagopusRenderObject {
  let pick_shader = match data {
    WithPoints(_) => lines_wgsl()
    WithTriangles(_) => polyline_wgsl()
  }
  lagopus_object(
    LagopusObjectOptions::{
      label: label.or("object"),
      shader: shader.or(pick_shader),
      topology: topology.or(TriangleList),
      data,
      indices: indices.or(None),
      get_params: get_params.or(None),
    }.as_value(),
  )
}

///|
/// Creates a group of render objects in the Lagopus rendering system, allowing
/// multiple render objects to be combined and managed as a single unit.
///
/// Parameters:
///
/// * `children` : An array of `LagopusRenderObject`s that will be grouped
/// together. These objects can be created using functions like `object()` or
/// other `group()` calls.
///
/// Returns a new `LagopusRenderObject` that represents the group of render
/// objects.
///
/// Example:
///
/// ```moonbit
/// test "group" {
///   let triangle = @lagopus.object(data=ObjectData::WithPoints([]))
///   let circle = @lagopus.object(data=ObjectData::WithPoints([]))
///   let scene = @lagopus.group([triangle, circle])
///   inspect!(scene, content="[object Object]")
/// }
/// ```
pub fn group(children : Array[LagopusRenderObject]) -> LagopusRenderObject {
  let arr = JsArray::new()
  for child in children {
    arr.push(child.as_value())
  }
  lagopus_group(arr)
}
