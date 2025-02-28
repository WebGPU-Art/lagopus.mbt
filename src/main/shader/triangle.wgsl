
#import lagopus::perspective

struct Params {
  _pad: f32,
}

@group(0) @binding(0) var<uniform> uniforms: UBO;
@group(0) @binding(1) var<uniform> params: Params;

// main

struct VertexOut {
  @builtin(position) position: vec4f,
  @location(0) color: vec4f,
};

@vertex
fn vertex_main(
  @location(0) position: vec4f,
  @location(1) color: vec4f
) -> VertexOut {
  var output: VertexOut;
  let p = transform_perspective(position.xyz).point_position;
  let scale: f32 = 0.002;
  output.position = vec4(p[0] * scale, p[1] * scale, p[2] * scale, 1.0);
  // output.position = position;
  output.color = color;
  return output;
}

@fragment
fn fragment_main(vtx_out: VertexOut) -> @location(0) vec4f {
  return vtx_out.color;
}
