shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0);

bool is_body(vec3 c)
{
	return
		distance(c, vec3(0.698,0.698,0.698)) < 0.01 || 
		distance(c, vec3(0.616,0.616,0.612)) < 0.01 || 
		distance(c, vec3(0.529,0.529,0.529)) < 0.01 || 
		distance(c, vec3(0.439,0.435,0.435)) < 0.01; 
}

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);

	if (is_body(tex.rgb))
	{
		float gray = dot(tex.rgb, vec3(0.333));
		COLOR.rgb = gray * tint_color.rgb;
	}
	else
	{
		COLOR.rgb = tex.rgb;
	}

	COLOR.a = tex.a;
}
