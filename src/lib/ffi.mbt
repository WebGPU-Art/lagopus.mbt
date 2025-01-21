///| a very naive ffi implementation for JS Promise
type Promise

///|
pub extern "js" fn Promise::then(
  self : Promise,
  f : (JsValue) -> JsValue
) -> Promise =
  #| (self, f) => self.then(f)

///|
pub extern "js" fn Promise::catch_error(
  self : Promise,
  f : (JsValue) -> Unit
) -> Promise =
  #| (self, f) => self.catch(f)

///|
pub extern "js" fn js_undefined() -> JsValue =
  #| () => undefined

///|
pub(all) type Window

///|
pub extern "js" fn window() -> Window =
  #| () => window

///| set_onresize
pub extern "js" fn Window::set_onresize(self : Window, f : () -> Unit) -> Unit =
  #| (window, f) => window.onresize = f

///|onload
pub extern "js" fn Window::set_onload(self : Window, f : () -> Unit) -> Unit =
  #| (window, f) => window.onload = f

///|
pub(all) type Document

///|
pub extern "js" fn Window::document(self : Window) -> Document =
  #| () => document

///|
type Element

///| query_selector
pub extern "js" fn Document::query_selector(
  self : Document,
  selector : String
) -> Element =
  #| (document, selector) => document.querySelector(selector)

///|
extern "js" fn lagopus_object(options : JsValue) -> LagopusRenderObject =
  #| (options) => Lagopus.object(options)

///|
extern "js" fn lagopus_group(children : JsArray) -> LagopusRenderObject =
  #| (children) => ({type: "group", children})

///| log_js_value
pub extern "js" fn log_js_value(value : JsValue) -> Unit =
  #| (value) => console.log(value)

///|
pub extern "js" fn math_random(n : Float) -> Float =
  #| (n) => Math.random() * n

///|
extern "js" fn lagopus_comp_button(options : JsValue) -> LagopusRenderObject =
  #| (options) => {
  #|   console.log(options);
  #|   return Lagopus.compButton(options, options.on_click)
  #| }
