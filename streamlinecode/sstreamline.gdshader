shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_back;

const float point_scale = 30.0;
uniform vec4 albedo : source_color = vec4(1.0,0.0,0.0,0.5);

void vertex() {
	float distcamera = length(CAMERA_POSITION_WORLD - VERTEX);
	POINT_SIZE = point_scale/distcamera;
	COLOR = albedo;
}

void fragment() {
	ALBEDO = COLOR.rgb;
	float rsq = (POINT_COORD.x-0.5)*(POINT_COORD.x-0.5) + (POINT_COORD.y-0.5)*(POINT_COORD.y-0.5);
	if (rsq > 0.25)
		discard;
	ALPHA = COLOR.a*(1.0 - cos(rsq*8.0*PI))*0.5;
	ALBEDO.b = mod(TIME*1.1 + 1.0 - UV.x, 1.0);
	ALBEDO.r = 1.0 - ALBEDO.b;
}

void light() {
    DIFFUSE_LIGHT += ATTENUATION * LIGHT_COLOR;
}