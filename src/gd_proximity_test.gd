extends ColorRect

# get the shader params
var self_position = material.get_shader_parameter('self_position')
var target_position = material.get_shader_parameter('target_position')

func _process(delta):
	position = get_viewport().get_mouse_position()
	
	# chance_shader params to desired value
	self_position = position # position you want
	target_position = Vector2(0, 0) # position you want
	
	# update the shader params to the new value
	material.set_shader_parameter('self_position', self_position)
	material.set_shader_parameter('target_position', target_position)
