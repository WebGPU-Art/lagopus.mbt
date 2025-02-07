// import { atomClearColor } from "./global.mjs";

///|
struct Store {} derive(Default)

///|
let store : Store = Store::default()

///|
fn dispatch(a : Action) -> Unit {
  match a {
    Action::Noop => ()
  }
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
}

///|
/// Reads and parses URL search parameters into a structured format. Handles
/// specific parameters:
///
/// * "tab": Determines which visualization to display
/// * "read": Controls if data should be read
/// * "axis": Controls the visibility of coordinate axes
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
  { tab: Tab::from_string(tab), read, show_axis }
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
  @lagopus.setup_mouse_events(canvas)

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
