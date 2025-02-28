
#import lagopus::perspective

#import lagopus::colors

// main

struct VertexOut {
  @builtin(position) position: vec4f,
  @location(1) color: vec3f,
};

@vertex
fn vertex_main(
  @location(0) position: vec3f,
  @location(1) brush: u32,
  @location(2) direction: vec3f,
  @location(3) width: f32,
) -> VertexOut {
  var output: VertexOut;
  var ret = transform_perspective(position);
  let p = ret.point_position;
  let scale: f32 = 0.002;

  let ret_next = transform_perspective(position + direction);
  let p_next = ret_next.point_position;

  var line_next_2d = p_next - p;
  // take viewport ratio into account
  let canvas_direction_2d = vec2(line_next_2d.x, line_next_2d.y * uniforms.viewport_ratio);
  var perp = normalize(vec2(-canvas_direction_2d.y, canvas_direction_2d.x));
  perp = vec2f(perp.x, perp.y / uniforms.viewport_ratio);
  let perspective_scale = clamp(1. / ret.r * uniforms.scale, -20., 20.);
  let brush_direction = vec4(perp * width * 0.5 * scale * perspective_scale, 0.0, 0.0);

  output.position = vec4(p.xyz * scale, 1.0);

  if brush == 1u {
    output.position += brush_direction;
  } else {
    output.position -= brush_direction;
  }

  // output.color = hsl(0.14, 1.0, 0.2);
  return output;
}

const middle: f32 = 50.0;
const limit: f32 = 48.0;

@fragment
fn fragment_main(vtx_out: VertexOut) -> @location(0) vec4f {
  // return vec4f(vtx_out.color, 1.0);
  return vec4(0.7, 0.7, 0.7, 1.);
}
