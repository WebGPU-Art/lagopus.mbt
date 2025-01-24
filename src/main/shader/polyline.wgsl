
#import lagopus::perspective

#import lagopus::colors

// main

struct VertexOut {
  @builtin(position) position: vec4f,
  @location(0) original: vec3f,
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

  let direction_unit = normalize(direction);
  let p_next = transform_perspective(position + direction_unit).point_position;

  let canvas_direction = normalize(p_next - p).xy;
  let perp = vec2(canvas_direction.y, -canvas_direction.x);
  var perspective_scale = 1. / ret.r;
  if perspective_scale > 0. {
    perspective_scale = min(20., perspective_scale);
  } else if perspective_scale < 0. {
    perspective_scale = max(-20., perspective_scale);
  }
  let brush_direction = vec4(perp * width * 0.5 * scale * perspective_scale, 0.0, 0.0);


  output.position = vec4(p.xyz * scale, 1.0);
  output.original = output.position.xyz;
  output.color = hsl(0.14, 1.0, 0.2);

  if brush == 1u {
    output.position += brush_direction;
  } else {
    output.position -= brush_direction;
  }

  return output;
}

const middle: f32 = 50.0;
const limit: f32 = 48.0;

@fragment
fn fragment_main(vtx_out: VertexOut) -> @location(0) vec4f {
  // return vec4f(vtx_out.color, 1.0);
  return vec4(0.7, 0.7, 0.7, 1.);
}
