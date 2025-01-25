///|
fn comp_spiral() -> @lagopus.LagopusRenderObject!@lagopus.BuilderError {
  guard true else { raise @lagopus.BuilderError("ok") }
  let vertexes : Array[Vertex] = []
  for i = 0; i < 200; i = i + 1 {
    let x = i.to_float() * 3.0
    let radius = 2.0.to_float() * i.to_float()
    let speed = 0.2
    let y = @math.sin(speed * i.to_double()).to_float() * radius
    let z = @math.cos(speed * i.to_double()).to_float() * radius
    vertexes.push({
      position: @lagopus.V3::make(x~, y~, z~),
      color: Color::white(),
    })
  }
  let triangles = @lagopus.create_vertex_data!(vertexes, width=8.0)
  let data : @lagopus.ObjectData = WithTriangles(triangles)
  @lagopus.object(data~, topology=LineStrip, shader=polyline_wgsl)
  // @lagopus.group([])
}
