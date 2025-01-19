///|
enum Tab {
  Demo
}

///|
fn Tab::default() -> Tab {
  Demo
}

///|
fn Tab::from_string(s : String) -> Tab {
  match s {
    "demo" => Demo
    _ => Demo
  }
}

///|
let none : @lagopus.LagopusRenderObject = @lagopus.group([])

///|
fn comp_container(
  params : SearchParams
) -> @lagopus.LagopusRenderObject!@lagopus.BuilderError {
  guard true else { raise @lagopus.BuilderError("ok") }
  @lagopus.group([])
}
