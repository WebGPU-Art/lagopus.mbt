///|
struct Atom[T] {
  mut value : T
}

///|
pub fn Atom::with_value[T](value : T) -> Atom[T] {
  { value, }
}

///|
pub fn Atom::deref[T](self : Atom[T]) -> T {
  self.value
}

///|
pub fn Atom::reset[T](self : Atom[T], value : T) -> Unit {
  self.value = value
}

///| value that retained when code refreshes by Vite
pub(all) struct RetainedAtom {
  name : String
  // value stroed in JavaScript runtime
}

///|
pub fn RetainedAtom::with_value[T : JsValueTrait](
  value : T,
  loc~ : SourceLoc = _
) -> RetainedAtom {
  retain_atom_reset(loc.to_string(), value.to_value())
  RetainedAtom::{ name: loc.to_string() }
}

///|
pub extern "js" fn retain_atom_reset(name : String, value : JsValue) -> Unit =
  #| (name, value) => {
  #|   if (window.retainedAtoms === undefined) { window.retainedAtoms = {} };
  #|   window.retainedAtoms[name] = value;
  #| }

///|
pub fn RetainedAtom::deref[T : JsValueTrait](self : RetainedAtom) -> T {
  let value = retain_atom_deref(self.name)
  JsValueTrait::from_value(value)
}

///|
pub extern "js" fn retain_atom_deref(name : String) -> JsValue =
  #| (name) => {
  #|   if (window.retainedAtoms === undefined) { window.retainedAtoms = {} };
  #|   return window.retainedAtoms[name];
  #| }

///|
pub fn RetainedAtom::reset[T : JsValueTrait](
  self : RetainedAtom,
  value : T
) -> Unit {
  retain_atom_reset(self.name, value.to_value())
}
