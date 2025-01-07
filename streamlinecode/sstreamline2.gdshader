shader_type spatial;
render_mode cull_back;

uniform vec4 albedo : source_color = vec4(0.0,0.0,1.0,1.0);

varying float integrationtime;
uniform float rad = 0.02;

void vertex() {
	COLOR = albedo + vec4(UV.x, 0.0, 0.0, 0.0);
	VERTEX += NORMAL*UV.y*rad;
	integrationtime = UV.x;
}

void fragment() {
	ALBEDO = COLOR.rgb;
	float tt = mod(TIME*0.5 + 1.0 - integrationtime*12.0, 1.0);
	if (tt < 0.1)
		ALBEDO.y = 1.0;
}

