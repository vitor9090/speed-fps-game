extends Camera3D

@export var sensitivity = 0.01

@export var standing_height = 0.5
@export var crouch_height = 0.15

@export var target:NodePath = ''

var debug_cam_speed = 10.0

enum CAM_MODES{
	DEBUG,
	PLAY
}

@export var camera_mode = CAM_MODES.PLAY 

func _ready():
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(ev):
	if ev is InputEventMouseMotion:
		rotation.x += -ev.relative.y * sensitivity
		rotation.y += -ev.relative.x * sensitivity
		
		rotation.x = clamp(rotation.x, -1.55, 1.55)

func _process(delta):
	if $RayCast3d.is_colliding():
		if $RayCast3d.get_collider().is_in_group('interactable'):
			print($RayCast3d.get_collider())
	
	match camera_mode:
		CAM_MODES.DEBUG:
			var move_vector = Vector3(
				Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
				Input.get_action_strength("debug_cam_up") - Input.get_action_strength("debug_cam_down"),
				Input.get_action_strength("move_foward") - Input.get_action_strength("move_down")
				)
			
			position -= ((transform.basis.z * move_vector.z) + (transform.basis.y * move_vector.y) + (transform.basis.x * move_vector.x)) * debug_cam_speed * delta
			
			if Input.is_action_just_pressed("debug_cam_activate"):
				camera_mode = CAM_MODES.PLAY
				
		CAM_MODES.PLAY:
			if !target.is_empty():
				position.x = get_node(target).position.x
				
				if get_node(target).crouching:
					position.y = lerp(position.y + standing_height, get_node(target).position.y + standing_height, 0.4)
				else:
					position.y = lerp(position.y + crouch_height, get_node(target).position.y + crouch_height, 0.4)

				position.z = get_node(target).position.z
				
			if Input.is_action_just_pressed("debug_cam_activate"):
				camera_mode = CAM_MODES.DEBUG
