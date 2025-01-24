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
pub fn V3::make(x? : Float, y? : Float, z? : Float) -> V3 {
  V3::{ x: x.or_default(), y: y.or_default(), z: z.or_default() }
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

///|
pub fn V3::to_array(self : V3) -> Array[Float] {
  [self.x, self.y, self.z]
}

///| turns into Array
pub fn V3::to_js_value(self : V3) -> JsValue {
  JsArray::new()
  ..push(JsValue::from_number(self.x))
  ..push(JsValue::from_number(self.y))
  ..push(JsValue::from_number(self.z))
  .to_value()
}

///|
pub fn V3::from_js_value(value : JsValue) -> V3 {
  let arr = JsArray::from(value)
  V3::new(
    arr.get(0).to_number(),
    arr.get(1).to_number(),
    arr.get(2).to_number(),
  )
}

///|
pub fn V3::from_quaternion(q : @quaternion.Quaternion) -> V3 {
  let x = q.x
  let y = q.y
  let z = q.z
  V3::new(x, y, z)
}

// V2

///|
pub struct V2 {
  x : Float
  y : Float
}

///|
pub fn V2::new(x : Float, y : Float) -> V2 {
  V2::{ x, y }
}

///|
pub fn V2::make(x~ : Float, y~ : Float) -> V2 {
  V2::{ x, y }
}

///|
pub fn V2::to_string(self : V2) -> String {
  "V2 { x: \{self.x} y: \{self.y} }"
}

///|
pub fn V2::op_add(self : V2, other : V2) -> V2 {
  V2::new(self.x + other.x, self.y + other.y)
}

///|
pub fn V2::op_sub(self : V2, other : V2) -> V2 {
  V2::new(self.x - other.x, self.y - other.y)
}

///|
pub fn V2::scale(self : V2, other : Float) -> Float {
  self.x * other + self.y * other
}

///|
pub fn V2::dot(self : V2, other : V2) -> Float {
  self.x * other.x + self.y * other.y
}

///|
pub fn V2::to_js_value(self : V2) -> JsValue {
  JsArray::new()
  ..push(JsValue::from_number(self.x))
  ..push(JsValue::from_number(self.y))
  .to_value()
}

///|
pub fn V2::from_js_value(value : JsValue) -> V2 {
  let arr = JsArray::from(value)
  V2::new(arr.get(0).to_number(), arr.get(1).to_number())
}
