///|
pub struct V3 {
  x : Float
  y : Float
  z : Float
}

///|
pub fn V3::new(x : Float, y : Float, z : Float) -> V3 {
  V3::{ x, y, z }
}

///|
pub fn V3::make(x~ : Float, y~ : Float, z~ : Float) -> V3 {
  V3::{ x, y, z }
}

///|
pub fn V3::to_string(self : V3) -> String {
  "V3 { x: \{self.x} y: \{self.y} z: \{self.z} }"
}

///|
pub fn V3::op_add(self : V3, other : V3) -> V3 {
  V3::new(self.x + other.x, self.y + other.y, self.z + other.z)
}

///|
pub fn V3::op_sub(self : V3, other : V3) -> V3 {
  V3::new(self.x - other.x, self.y - other.y, self.z - other.z)
}

///|
pub fn V3::scale(self : V3, other : Float) -> Float {
  self.x * other + self.y * other + self.z * other
}

///|
pub fn V3::dot(self : V3, other : V3) -> Float {
  self.x * other.x + self.y * other.y + self.z * other.z
}

///|
pub fn V3::cross(self : V3, other : V3) -> V3 {
  V3::new(
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x,
  )
}

///| turns into Array
pub fn V3::to_js_value(self : V3) -> JsValue {
  JsArray::new()
  ..push(JsValue::from_number(self.x))
  ..push(JsValue::from_number(self.y))
  ..push(JsValue::from_number(self.z))
  .to_value()
}
