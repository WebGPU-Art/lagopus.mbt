// import { atomClearColor } from "./global.mjs";

///|
struct Store {} derive(Default)

///|
enum Action {
  Noop
}

///|
impl @lagopus.JsValueTrait for Action with to_value(self : Action) -> @lagopus.JsValue {
  @lagopus.js_undefined()
}

///|
impl @lagopus.JsValueTrait for Action with from_value(value : @lagopus.JsValue) -> Action {
  Noop
}

///|
fn dispatch(a : Action) -> Unit {
  match render_app?() {
    Ok(_) => ()
    Err(e) => println("\{e}")
  }
}

///|
/// Represents parameters parsed from URL search string for configuring
/// visualization options.
///
/// Parameters:
///
/// * `tab` : The current visualization tab, indicating which visualization to
/// display. Valid values include `QuatCurve`, `HyperCube`, `HyperCubeGrid`,
/// `FlyCity`, `LampTree`, `QuatTree`, `QuatProduct`, `PrimeWalk`,
/// `SphereTessellation`, and `CubicArray`.
/// * `read` : Controls whether to read data from storage. Defaults to `true` if
/// not specified in URL.
/// * `show_axis` : Controls the visibility of coordinate axes in the
/// visualization. Defaults to `true` if not specified in URL.
/// * `times` : Optional integer between 0 and 10 controlling iteration count for
/// recursive visualizations. When not specified in URL or invalid, defaults to
/// `None`.
///
/// Example:
///
/// ```moonbit
/// test "search_params" {
///   let params = SearchParams::{
///     tab: QuatCurve,
///     read: true,
///     show_axis: true,
///     times: Some(5),
///   }
///   inspect!(params.show_axis, content="true")
///   inspect!(params.times, content="Some(5)")
/// }
/// ```
struct SearchParams {
  ///| The current visualization tab
  tab : Tab
  ///| Whether to read camera position from localStorage
  read : Bool
  ///| Whether to show coordinate axes
  show_axis : Bool
  ///| Iteration count for recursive visualizations(0-10), only work for some tabs
  times : Int?
}

///|
/// Reads and parses URL search parameters into a structured format. Handles
/// specific parameters:
///
/// * "tab": Determines which visualization to display
/// * "read": Controls if data should be read
/// * "axis": Controls the visibility of coordinate axes
/// * "times": Controls iteration times for certain visualizations
///
/// Returns a `SearchParams` structure containing the parsed parameters with the
/// following fields:
///
/// * `tab`: The current visualization tab, parsed from "tab" parameter
/// * `read`: A boolean indicating whether to read data, defaults to `true`
/// * `show_axis`: A boolean controlling axis visibility, defaults to `true`
/// * `times`: An optional integer between 0 and 10 controlling iteration count
///
/// Example:
///
/// ```moonbit
/// test "read_params" {
///   // Assuming URL: "http://example.com?tab=quat-curve&read=false&axis=true&times=5"
///   let params = read_params()
///   inspect!(params.read, content="false")
///   inspect!(params.show_axis, content="true")
///   inspect!(params.times, content="Some(5)")
/// }
/// ```
fn read_params() -> SearchParams {
  let location = @dom_ffi.window().location()
  let params = @dom_ffi.new_url_search_params(location.search())
  let tab = params.get("tab")
  let read = match params.get("read") {
    "true" => true
    "false" => false
    _ => true
  }
  let show_axis = match params.get("axis") {
    "true" => true
    "false" => false
    _ => true
  }
  let times = match params.get("times") {
    "0" => Some(0)
    "1" => Some(1)
    "2" => Some(2)
    "3" => Some(3)
    "4" => Some(4)
    "5" => Some(5)
    "6" => Some(6)
    "7" => Some(7)
    "8" => Some(8)
    "9" => Some(9)
    "10" => Some(10)
    _ => None
  }
  { tab: Tab::from_string(tab), read, show_axis, times }
}

///|
fn render_app() -> Unit!@lagopus.BuilderError {
  let params = read_params()
  let tree = comp_container!(params)
  @lagopus.render_lagopus_tree(
    tree,
    @lagopus.DispatchFn::from(dispatch).to_js_func(),
  )
  @lagopus.paint_lagopus_tree()
}

///|
fn create_app() -> Unit {
  @lagopus.initialize_canvas_textures()
  // atomClearColor.reset({ r: 0.0, g: 0.0, b: 0.0, a: 0.0 });
  let window = @lagopus.window()
  let document = window.document()
  let canvas = document.query_selector("canvas")
  render_app?().unwrap()
  window.set_onresize(fn() {
    @lagopus.reset_canvas_size(canvas)
    @lagopus.initialize_canvas_textures()
    @lagopus.paint_lagopus_tree()
  })
  @lagopus.reset_canvas_size(canvas)

  // window.__caterfoilHandleCompilationInfo = (e, code) => {
  //   if (e.messages.length) {
  //     console.error(e);
  //   }
  // };
  // // setupMouseEvents(canvas);

  @lagopus.load_gamepad_control()
  @lagopus.paint_lagopus_tree()
}

///|
fn main {
  @lagopus.connect_retained_atom_to_srorage(
    "lagopus.mbt",
    read=read_params().read,
  )
  let _ret = @lagopus.initialize_context().then(fn(_x) {
    create_app()
    @lagopus.js_undefined()
  })

}

// declare global {
//   /** dirty hook for extracting error messages */
//   var __caterfoilHandleCompilationInfo: (info: GPUCompilationInfo, code: string) => void;
// }
