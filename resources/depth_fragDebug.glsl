#version 330 core

uniform sampler2D Texture0;
in vec2 fTex;

/* write out depth to show transforms working */
out vec4 Outcolor;

void main() {
	Outcolor = vec4(0, gl_FragCoord.z, gl_FragCoord.z, 1.0);
	vec4 texColor0 = texture(Texture0, fTex);
	Outcolor = texColor0;
}

