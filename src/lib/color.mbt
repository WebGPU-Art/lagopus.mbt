///|
pub(all) struct Color {
  r : Float
  g : Float
  b : Float
  a : Float
}

///|
pub fn Color::new(r? : Float, g? : Float, b? : Float, a? : Float) -> Color {
  Color::{
    r: r.or_default(),
    g: g.or_default(),
    b: b.or_default(),
    a: a.or_else(fn() { 1.0 }),
  }
}

///|
pub fn Color::white(a? : Float) -> Color {
  Color::new(r=1.0, g=1.0, b=1.0, a=a.or(1))
}

///|
pub fn Color::black(a? : Float) -> Color {
  Color::new(r=0.0, g=0.0, b=0.0, a=a.or(1))
}

///|
pub fn Color::red(a? : Float) -> Color {
  Color::new(r=1.0, g=0.0, b=0.0, a=a.or(1))
}

///|
pub fn Color::green(a? : Float) -> Color {
  Color::new(r=0.0, g=1.0, b=0.0, a=a.or(1))
}

///|
pub fn Color::blue(a? : Float) -> Color {
  Color::new(r=0.0, g=0.0, b=1.0, a=a.or(1))
}

///|
pub fn Color::yellow(a? : Float) -> Color {
  Color::new(r=1.0, g=1.0, b=0.0, a=a.or(1))
}

///|
pub fn Color::magenta(a? : Float) -> Color {
  Color::new(r=1.0, g=0.0, b=1.0, a=a.or(1))
}

///|
pub fn Color::cyan(a? : Float) -> Color {
  Color::new(r=0.0, g=1.0, b=1.0, a=a.or(1))
}

///|
pub fn Color::gray(a? : Float) -> Color {
  Color::new(r=0.5, g=0.5, b=0.5, a=a.or(1))
}

// orange
///|
pub fn Color::orange(a? : Float) -> Color {
  Color::new(r=1.0, g=0.5, b=0.0, a=a.or(1))
}

///|
pub fn Color::blue_brigher(a? : Float) -> Color {
  Color::new(r=0.5, g=0.5, b=1.0, a=a.or(1))
}
