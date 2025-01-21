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

///|
type SlideHandler[Action] (V2, DispatchFn[Action]) -> Unit

///|
type SlideHandlerJsValue (JsValue, DispatchFnJsValue) -> Unit

///|
fn SlideHandler::from[Action](
  f : (V2, DispatchFn[Action]) -> Unit
) -> SlideHandler[Action] {
  SlideHandler(f)
}

///|
fn SlideHandler::to_js_func[Action : JsValueTrait](
  self : SlideHandler[Action]
) -> SlideHandlerJsValue {
  fn(v : JsValue, op : DispatchFnJsValue) {
    let f = self._
    f(V2::from_js_value(v), DispatchFn::from_func(op))
  }
}

///|
extern "js" fn SlideHandlerJsValue::to_js_value(
  self : SlideHandlerJsValue
) -> JsValue =
  #| (self) => self

// drag

///|
type DragHandler[Action] (V3, DispatchFn[Action]) -> Unit

///|
type DragHandlerJsValue (JsValue, DispatchFnJsValue) -> Unit

///|
fn DragHandler::from[Action](
  f : (V3, DispatchFn[Action]) -> Unit
) -> DragHandler[Action] {
  DragHandler(f)
}

///|
fn DragHandler::to_js_func[Action : JsValueTrait](
  self : DragHandler[Action]
) -> DragHandlerJsValue {
  fn(v : JsValue, op : DispatchFnJsValue) {
    let f = self._
    f(V3::from_js_value(v), DispatchFn::from_func(op))
  }
}

///|
extern "js" fn DragHandlerJsValue::to_js_value(
  self : DragHandlerJsValue
) -> JsValue =
  #| (self) => self
