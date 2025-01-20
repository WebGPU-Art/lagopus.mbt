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
  options.set("size", JsValue::from_number(size.or(20)))
  options.set(
    "color",
    color.or(Color::new(r=1.0, g=1.0, b=1.0, a=1.0)).to_js_value(),
  )
  options.set(
    "on_click",
    MouseHandler::from(on_click).to_js_func().to_js_value(),
  )
  lagopus_comp_button(options.to_value())
}
