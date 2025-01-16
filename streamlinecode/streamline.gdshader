shader_type spatial;
render_mode cull_disabled;
uniform sampler2D streamline : repeat_disable;
uniform float streamlineYstretch = 1.0;

varying float scalar;

// The TubeTrailMesh axis has 0<UV.y<0.5 (the rest maps the caps)

void vertex() {
	float tu = UV.y*2.0*streamlineYstretch;
	vec4 s = texture(streamline, vec2(tu, 0.0));
	vec4 svx = texture(streamline, vec2(tu, 0.5));
	vec4 svz = texture(streamline, vec2(tu, 1.0));
	scalar = s.w;
	float frad = -scalar*0.135 + 1.0;
	float phase = abs(100.0 - tu*10.0 + TIME*0.41);
	if (fract(phase) < 0.1)
		frad *= 0.5;
	vec3 p = VERTEX;

	VERTEX = s.xyz + (p.x*svx.xyz + p.z*svz.xyz)*frad;
}

void fragment() {
	ALBEDO.r = (scalar+1.0)/3.0;
//	if (UV.y >= 0.45)
//		ALBEDO.yz = vec2(0.0, 0.0);
	//if (UV.y > 0.8)
	//	ALBEDO.yz = vec2(0.0, 0.0);
	//ALBEDO = vec3(s.x, s.x, s.x);
}
