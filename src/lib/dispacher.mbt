///| MoonBit does not allow polymorphic types in FFI functions, need to convert to concrete types before using them in FFI functions.
///|
type DispatchFn[Action] (Action) -> Unit

///|
type DispatchFnJsValue (JsValue) -> Unit

///|
fn DispatchFnJsValue::to_js_value(self : DispatchFnJsValue) -> JsValue {
  let f = JsFunction::from_dispatch_fn(self)
  f.to_js_value()
}

///|
pub fn DispatchFn::to_js_func[Action : JsValueTrait](
  self_ : DispatchFn[Action]
) -> DispatchFnJsValue {
  fn(v : JsValue) {
    let f = self_._
    let v = Action::from_value(v)
    f(v)
  }
}

///|
pub fn DispatchFn::to_js_value[Action : JsValueTrait](
  self_ : DispatchFn[Action]
) -> JsValue {
  self_.to_js_func().to_js_value()
}

///|
pub fn DispatchFn::from[Action : JsValueTrait](
  f : (Action) -> Unit
) -> DispatchFn[Action] {
  DispatchFn(f)
}

///|
pub fn DispatchFn::from_func[Action : JsValueTrait](
  f : DispatchFnJsValue
) -> DispatchFn[Action] {
  let d = fn(a : Action) {
    let b = a.to_value()
    let ff = f._
    ff(b)
  }
  DispatchFn::from(d)
}

///|
type MouseHandler[Action] (@dom_ffi.MouseEvent, DispatchFn[Action]) -> Unit

///|
type MouseHandlerJsValue (@dom_ffi.MouseEvent, DispatchFnJsValue) -> Unit

///|
fn MouseHandler::from[Action](
  f : (@dom_ffi.MouseEvent, DispatchFn[Action]) -> Unit
) -> MouseHandler[Action] {
  MouseHandler(f)
}

///|
fn MouseHandler::to_js_func[Action : JsValueTrait](
  self : MouseHandler[Action]
) -> MouseHandlerJsValue {
  fn(m : @dom_ffi.MouseEvent, op : DispatchFnJsValue) {
    let f = self._
    f(m, DispatchFn::from_func(op))
  }
}

///|
extern "js" fn MouseHandlerJsValue::to_js_value(
  self : MouseHandlerJsValue
) -> JsValue =
  #| (self) => self
