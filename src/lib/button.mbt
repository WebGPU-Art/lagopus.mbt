///|
let default_button_size : Float = 20.0

///|
pub fn comp_button[Action : JsValueTrait](
  position~ : V3,
  size? : Float,
  color? : Color,
  on_click~ : (@dom_ffi.MouseEvent, DispatchFn[Action]) -> Unit
) -> LagopusRenderObject!BuilderError {
  guard true else { raise BuilderError("comp_button: guard failed") }
  let options = JsObject::new()
  options.set("position", position.to_js_value())
  options.set("size", JsValue::from_number(size.or(default_button_size)))
  options.set(
    "color",
    color.or(Color::new(r=1.0, g=0, b=1.0, a=1.0)).to_js_value(),
  )
  options.set(
    "on_click",
    MouseHandler::from(on_click).to_js_func().to_js_value(),
  )
  lagopus_comp_button(options.to_value())
}

///|
pub fn comp_flat_button[Action : JsValueTrait](
  position~ : V3,
  size? : Float,
  color? : Color,
  on_click~ : (@dom_ffi.MouseEvent, DispatchFn[Action]) -> Unit
) -> LagopusRenderObject!BuilderError {
  guard true else { raise BuilderError("comp_flat_button: guard failed") }
  let options = JsObject::new()
  options.set("position", position.to_js_value())
  options.set("size", JsValue::from_number(size.or(default_button_size)))
  options.set(
    "color",
    color.or(Color::new(r=1.0, g=0, b=1.0, a=1.0)).to_js_value(),
  )
  options.set(
    "on_click",
    MouseHandler::from(on_click).to_js_func().to_js_value(),
  )
  lagopus_comp_flat_button(options.to_value())
}

///|
pub fn comp_slider[Action : JsValueTrait](
  position~ : V3,
  size? : Float,
  color? : Color,
  on_slide~ : (V2, DispatchFn[Action]) -> Unit
) -> LagopusRenderObject!BuilderError {
  guard true else { raise BuilderError("comp_slider: guard failed") }
  let options = JsObject::new()
  options.set("position", position.to_js_value())
  options.set("size", JsValue::from_number(size.or(default_button_size)))
  options.set(
    "color",
    color.or(Color::new(r=1.0, g=0, b=1.0, a=1.0)).to_js_value(),
  )
  options.set(
    "on_slide",
    SlideHandler::from(on_slide).to_js_func().to_js_value(),
  )
  lagopus_comp_slider(options.to_value())
}

///|
pub fn comp_drag_point[Action : JsValueTrait](
  position~ : V3,
  size? : Float,
  color? : Color,
  on_drag~ : (V3, DispatchFn[Action]) -> Unit
) -> LagopusRenderObject!BuilderError {
  guard true else { raise BuilderError("comp_drag_point: guard failed") }
  let options = JsObject::new()
  options.set("position", position.to_js_value())
  options.set("size", JsValue::from_number(size.or(default_button_size)))
  options.set(
    "color",
    color.or(Color::new(r=1.0, g=0, b=1.0, a=1.0)).to_js_value(),
  )
  options.set("on_drag", DragHandler::from(on_drag).to_js_func().to_js_value())
  lagopus_comp_drag_point(options.to_value())
}
