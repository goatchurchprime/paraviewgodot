shader_type spatial;
render_mode cull_disabled;
uniform sampler2D streamline : repeat_disable;
uniform float streamlineYstretch = 1.0;

// The TubeTrailMesh axis has 0<UV.y<0.5 (the rest maps the caps)
void vertex() {
	float tu = UV.y*2.0*streamlineYstretch;
	vec4 s = texture(streamline, vec2(tu, 0.0));
	vec4 svx = texture(streamline, vec2(tu, 0.5));
	vec4 svz = texture(streamline, vec2(tu, 1.0));
	vec3 p = VERTEX;
	VERTEX.x = s.x*0.5;
	VERTEX.z = p.x + s.z;
	VERTEX.y = p.z + s.y;
	
	VERTEX = s.xyz + p.x*svx.xyz + p.z*svz.xyz;
//	VERTEX = mix(VERTEX, s.xyz, 1.0);
//	VERTEX.y += p.x;
//	VERTEX.z += p.z;
	
//	if (s.x < 0.0)
//		VERTEX.x -= 1.0;
	//VERTEX.xyz = s.rgb;
	//VERTEX.x += sin(UV.y*10.0 + TIME);
	//VERTEX.y +=1 UV.y;
	//if (UV.x > 0.5)
	//	VERTEX.xyz = s.brg;
}

void fragment() {
	vec4 s = texture(streamline, vec2(UV.y*2.0, 0.0));
	if (UV.y >= 0.45)
		ALBEDO.yz = vec2(0.0, 0.0);
	else
		ALBEDO.x = 0.0;
	//if (UV.y > 0.8) 
	//	ALBEDO.yz = vec2(0.0, 0.0);
	//ALBEDO = vec3(s.x, s.x, s.x);
}
