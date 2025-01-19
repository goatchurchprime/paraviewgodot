shader_type spatial;
render_mode cull_back;

uniform vec4 albedo : source_color = vec4(0.0,0.0,1.0,1.0);

varying float integrationtime;
uniform float rad = 0.012;

uniform float streamvelx = 0.0;
uniform float streamtimetimefac = 1.0;
uniform float streamtimeoffset = 0.0;

void vertex() {
	COLOR = vec4(clamp(UV.y*6.0-4.0, 0.0, 0.5), 0.0, 1.0, 0.0);
	VERTEX += NORMAL*UV.y*rad;
	integrationtime = UV.x*streamtimetimefac + streamtimeoffset;
	VERTEX.x += integrationtime*streamvelx;
}

uniform float utimespeed = 0.5;
uniform float utimefac = 12.0;
uniform float stripewid = 0.05;
uniform float stripecancel = 0.2;
void fragment() {
	ALBEDO = COLOR.rgb;
	if (integrationtime < 0.0) {
		ALBEDO.r = 0.9;
		//discard;
	}
	float tt = mod(TIME*utimespeed + 20.0 - integrationtime*utimefac, 1.0);
	if (abs(tt - 0.5) < stripewid) {
		ALBEDO.g = 0.3;
		if (abs(integrationtime) < 0.01)
			ALBEDO.rg = vec2(1.0, 1.0);
	} else if (abs(tt - 0.5) > stripecancel) {
		discard;
	}
}
