shader_type spatial;
render_mode skip_vertex_transform, vertex_lighting, diffuse_lambert;

// Texture Parameters
uniform sampler2D albedo;
uniform sampler2D orm : hint_default_black;
uniform sampler2D normal : hint_normal;

// Retro Parameters
uniform float vertex_jitter_strength : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	
	float i = (1.0 - vertex_jitter_strength) * min(VIEWPORT_SIZE.x, VIEWPORT_SIZE.y) / 2.0;
	float w = (PROJECTION_MATRIX * vec4(VERTEX, 1.0)).w;
	VERTEX = round(VERTEX / w * i) / i * w;
	UV *= VERTEX.z;
}

void fragment() {
	vec2 uv = UV / VERTEX.z;
	
	ALBEDO = texture(albedo, uv).rgb;
	AO = texture(orm, uv).r;
	ROUGHNESS = texture(orm, uv).g;
	METALLIC = texture(orm, uv).b;
}