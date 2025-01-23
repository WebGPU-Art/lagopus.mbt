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
  @lagopus.group([
    @lagopus.object(data~),
    @lagopus.comp_button!(
      position=@lagopus.V3::make(x=40.0, y=0.0, z=0.0),
      color=Color::new(r=0.5, g=0.5, b=1.0, a=1.0),
      on_click=fn(_event, _dispatch : @lagopus.DispatchFn[Action]) -> Unit {
        println("Button clicked")
      },
    ),
    @lagopus.comp_flat_button!(
      position=@lagopus.V3::make(x=80.0, y=80.0, z=0.0),
      color=Color::new(r=0.5, g=0.5, b=1.0, a=1.0),
      on_click=fn(_event, _dispatch : @lagopus.DispatchFn[Action]) -> Unit {
        println("Button clicked")
      },
    ),
    @lagopus.comp_slider!(
      position=@lagopus.V3::make(x=80.0, y=-40.0, z=0.0),
      color=Color::new(r=0.5, g=0.5, b=1.0, a=1.0),
      on_slide=fn(delta, _dispatch : @lagopus.DispatchFn[Action]) -> Unit {
        println("Button clicked \{delta}")
      },
    ),
    @lagopus.comp_drag_point!(
      position=@lagopus.V3::make(x=200.0, y=0.0, z=0.0),
      color=Color::new(r=0.5, g=0.5, b=1.0, a=1.0),
      on_drag=fn(dalta, _dispatch : @lagopus.DispatchFn[Action]) -> Unit {
        println("Button clicked \{dalta}")
      },
    ),
    comp_spiral!(),
  ])
}
