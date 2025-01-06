shader_type spatial;
render_mode cull_back;

uniform vec4 albedo : source_color = vec4(0.0,0.0,1.0,1.0);

varying float integrationtime;

void vertex() {
	COLOR = albedo + vec4(UV.x, 0.0, 0.0, 0.0);
	VERTEX += -NORMAL*UV.y*0.2;
	integrationtime = UV.x;
}

void fragment() {
	ALBEDO = COLOR.rgb;
	float tt = mod(TIME*0.2 + 1.0 - integrationtime*4.0, 1.0);
	if (tt < 0.1)
		ALBEDO.y = 1.0;
/*	float rsq = (POINT_COORD.x-0.5)*(POINT_COORD.x-0.5) + (POINT_COORD.y-0.5)*(POINT_COORD.y-0.5);
	if (rsq > 0.25)
		discard;
	ALPHA = COLOR.a*(1.0 - cos(rsq*8.0*PI))*0.5;
	ALBEDO.b = mod(TIME*1.1 + 1.0 - UV.x, 1.0);
	ALBEDO.r = 1.0 - ALBEDO.b;
*/
}

