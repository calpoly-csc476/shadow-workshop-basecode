#version 330 core
uniform sampler2D Texture0;
uniform sampler2D shadowDepth;

out vec4 Outcolor;

in OUT_struct {
	vec3 fPos;
	vec3 fragNor;
	vec2 vTexCoord;
	vec4 fPosLS;
	vec3 vColor;
} in_struct;

/* returns 1 if shadowed */
/* called with the point projected into the light's coordinate space */
float TestShadow(vec4 LSfPos) {

	float bias = 0.01;

	//1: shift the coordinates from -1, 1 to 0 ,1
	vec3 shift = (LSfPos.xyz + vec3(1.0))/2.0;

	if (shift.x < 0.0 || shift.x > 1.0 ||
		shift.y < 0.0 || shift.y > 1.0 ||
		shift.z < 0.0 || shift.z > 1.0)
	{
		return 0.0;
	}

	//2: read off the stored depth (.) from the ShadowDepth, using the shifted.xy
	float curD = shift.z;
	float lightD = texture(shadowDepth, shift.xy).r;
	//3: compare to the current depth (.z) of the projected depth
	if (curD - bias > lightD)
	{
		//4: return 1 if the point is shadowed
		return 1.0;
	}
	else
	{
		return 0.0;
	}
}

void main() {

	float Shade = 0.0;
	float amb = 0.3;

	vec4 BaseColor = vec4(in_struct.vColor, 1);
	vec4 texColor0 = texture(Texture0, in_struct.vTexCoord);

	Shade = TestShadow(in_struct.fPosLS);

	Outcolor = amb*(texColor0) + (1.0-Shade)*texColor0*BaseColor;
}

