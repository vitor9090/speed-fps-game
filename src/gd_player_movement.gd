extends KinematicBody

var velocity = Vector3.ZERO
var force = Vector3.ZERO

var base_scale = scale
var crouch_scale = 0.5

var speed = 0
export (float) var max_speed = 500
export (float) var acceleration = 20;

var friction = 0
export (float) var air_friction = 1
export (float) var ground_friction = 30

export (float) var gravity = 15
export (float) var jump_force = 500

var crouching = true
var on_ground = false


func _physics_process(delta):
	var move_vector = Vector2(
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_foward")
		)
	
	if (move_vector.x != 0 || move_vector.y != 0):
		force = Vector3(
			(-$Camera.transform.basis.z.x * -move_vector.y) + $Camera.transform.basis.x.x * -move_vector.x, 
			force.y,
			(-$Camera.transform.basis.z.z * -move_vector.y) + $Camera.transform.basis.x.z * -move_vector.x
			)
			
	if on_ground:
		if (move_vector.length() != 0):
			if (speed < max_speed):
				speed += acceleration
			else:
				speed -= ground_friction
		else:
			speed -= ground_friction
	else:
		if (move_vector.length() != 0):
			speed += acceleration / 2
		else:
			speed -= air_friction
			
	speed = clamp(speed, 0, 12000)
	
	if Input.is_action_just_pressed("move_crouch"):
		if crouching:
			# translation.y -= base_scale.y + crouch_scale
			scale.y = crouch_scale
		else:
			translation.y += base_scale.y + 0.5
			scale.y = 1
		crouching = !crouching
		
	print(base_scale.y)
	
	for ray in $CollisionShape.get_children():	
		if !ray.is_colliding():
			force.y -= gravity
			
			on_ground = false
		else:
			force.y = 0
			
			on_ground = true
		
			if Input.is_action_just_pressed("move_jump"):
				force.y += jump_force
			
	velocity.x = force.x * speed * delta
	velocity.y = force.y * delta
	velocity.z = force.z * speed * delta
	
	#speed = clamp(speed, 0, max_speed)
	velocity.normalized()
	
	velocity = move_and_slide(velocity)
