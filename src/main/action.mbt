///|
enum Action {
  Noop
}

///|
extern "js" fn action_to_value(action : Action) -> @lagopus.JsValue =
  #| (action) => action

///|
extern "js" fn action_from_value(value : @lagopus.JsValue) -> Action =
  #| (value) => value

///|
impl @lagopus.JsValueTrait for Action with to_value(self : Action) -> @lagopus.JsValue {
  action_to_value(self)
}

///|
impl @lagopus.JsValueTrait for Action with from_value(value : @lagopus.JsValue) -> Action {
  action_from_value(value)
}
