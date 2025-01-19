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
  let vertexes : Array[Vertex] = [
    { position: Quaternion::new(x=0.0), color: Color::white() },
    { position: Quaternion::new(x=20.0), color: Color::white() },
    { position: Quaternion::new(x=20.0, y=20.0), color: Color::white() },
  ]
  let data : @lagopus.ObjectData = WithPoints(vertexes)
  @lagopus.group([@lagopus.object(data~, shader=triangle_wgsl)])
}
