extends Camera

export (float) var sensitivity = 0.01
export (float) var height = 2

func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(ev):
	if ev is InputEventMouseMotion:
		rotation.x += -ev.relative.y * sensitivity
		rotation.y += -ev.relative.x * sensitivity
		
		rotation.x = clamp(rotation.x, -1.60, 1.60)
		# print(rotation.x)

func _process(delta):
	translation.x = get_parent().translation.x 
	translation.y = lerp(translation.y, get_parent().translation.y * height, 0.5)
	translation.z = get_parent().translation.z
