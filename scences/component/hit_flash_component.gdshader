shader_type canvas_item;

// uniform은 쉐이더 외부에서 뭔가를 설정할 때 사용하는 변수
uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	// rgb채널에서 흰색값은 1.0
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR = final_color;
}
