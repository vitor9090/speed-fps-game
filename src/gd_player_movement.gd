extends KinematicBody

var velocity = Vector3.ZERO
var force:Vector2 = Vector2.ZERO

var base_scale:Vector3 = scale
var crouch_scale:float = 0.5

var speed:float = 10
export (float) var max_base_speed:float = 500
export (float) var max_speed:float = 2000
export (float) var acceleration:float = 20;

var friction = 0
export (float) var air_friction = 1
export (float) var ground_friction = 20
export (float) var ground_grip:float = 10.0
export (float) var air_grip:float = 1.0

export (float) var gravity = 15
export (float) var jump_force = 500

var jump_y = 0

export (bool) var crouching:bool = true
var colliding = false

enum GROUND_STATES{
	IDLE,
	MOVING,
}

enum POSITIONAL_STATES{
	ON_GROUND
	JUMPING,
	FALLING
}

var ground_state: int = GROUND_STATES.IDLE
var positional_state: int = POSITIONAL_STATES.FALLING

export (bool) var new_system:bool = true

# TODO: Add coyote jumping
# TODO: Refactor code to new system
# TODO: Move to new system

func _physics_process(delta):
	var move_vector = Vector2(
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_foward")
		)
	
	if (move_vector.x != 0 || move_vector.y != 0):
		force = Vector2(
			(-move_vector.y * -$Camera.transform.basis.z.x) + -move_vector.x * $Camera.transform.basis.x.x, 
			(-move_vector.y * -$Camera.transform.basis.z.z) + -move_vector.x * $Camera.transform.basis.x.z
			)
		force = force.normalized()
		
	if Input.is_action_just_pressed("move_crouch"):
		if crouching:
			scale.y = crouch_scale 
		else:
			translation.y += base_scale.y
			scale.y = base_scale.y
		crouching = !crouching
		
	match ground_state:
		GROUND_STATES.IDLE:
			if !new_system:
				if positional_state == POSITIONAL_STATES.ON_GROUND:
					speed -= ground_friction
				elif positional_state == POSITIONAL_STATES.JUMPING || positional_state == POSITIONAL_STATES.FALLING:
					speed -= air_friction

			else:
				if positional_state == POSITIONAL_STATES.ON_GROUND:
					velocity.x -= velocity.x * ground_friction * delta
					velocity.z -= velocity.z * ground_friction * delta
				else:
					velocity.x -= velocity.x * air_friction * delta
					velocity.z -= velocity.z * air_friction * delta

			if move_vector.length() != 0:
				ground_state = GROUND_STATES.MOVING

		GROUND_STATES.MOVING:
			if !new_system:
				if positional_state == POSITIONAL_STATES.ON_GROUND:
					if (speed < max_base_speed):
						speed += acceleration
					else:
						speed -= ground_friction
				elif positional_state == POSITIONAL_STATES.JUMPING || positional_state == POSITIONAL_STATES.FALLING:
					speed += acceleration / 2
			else:
				if positional_state == POSITIONAL_STATES.ON_GROUND:
					velocity.x -= velocity.x * ground_grip * delta
					velocity.z -= velocity.z * ground_grip * delta
					
					velocity.x += force.x * (speed * ground_grip) * delta
					velocity.z += force.y * (speed * ground_grip) * delta
				else:
					velocity.x -= velocity.x * air_grip * delta
					velocity.z -= velocity.z * air_grip * delta

					velocity.x += force.x * 25 * delta
					velocity.z += force.y * 25 * delta

			if move_vector.length() == 0:
				ground_state = GROUND_STATES.IDLE

	match positional_state:
		POSITIONAL_STATES.ON_GROUND:
			jump_y = 0
			
			if Input.is_action_just_pressed("move_jump"):
				jump_y += jump_force
				positional_state = POSITIONAL_STATES.JUMPING
			
			if !colliding:
				positional_state = POSITIONAL_STATES.FALLING
		
		POSITIONAL_STATES.FALLING:
			jump_y -= gravity
			
			if colliding:
				positional_state = POSITIONAL_STATES.ON_GROUND
						
		POSITIONAL_STATES.JUMPING:
			jump_y -= gravity
			
			if jump_y < 0:
				positional_state = POSITIONAL_STATES.FALLING


	if !new_system:
		velocity.x = force.x * speed * delta
		velocity.z = force.y * speed * delta
	
	velocity.y = jump_y * delta
	
	velocity = move_and_slide(velocity)
	


func _on_Area_body_entered(body):
	if body.get_parent() != self && body != self:
		colliding = true


func _on_Area_body_exited(body):
	if body.get_parent() != self && body != self:
		colliding = false
