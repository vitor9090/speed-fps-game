extends CharacterBody3D

var _velocity = Vector3.ZERO
var force:Vector2 = Vector2.ZERO

@onready var base_scale:Vector3 = $CollisionShape3D.scale
var crouch_scale:float = 0.2

var speed:float = 10
@export var max_base_speed:float = 500
@export var max_speed:float = 2000
@export var acceleration:float = 20;

var friction = 0
@export  var air_friction = 1
@export  var ground_friction = 20
@export  var ground_grip:float = 10.0
@export  var air_grip:float = 1.0

@export  var gravity = 15
@export  var jump_force = 500

var jump_y = 0
var is_on_ground:bool = false

var coyote_timer = 0
@export  var coyote_timer_max = 0.15

@export var crouching:bool = true
var can_get_up:bool = true

enum GROUND_STATES{
	IDLE,
	MOVING,
}

enum POSITIONAL_STATES{
	ON_GROUND,
	JUMPING,
	FALLING
}

var ground_state: int = GROUND_STATES.IDLE
var positional_state: int = POSITIONAL_STATES.FALLING

var has_camera:bool = false

var health:int = 0
@export var max_health:int = 4

# TODO: Variable friction based checked speed # Done!
# TODO: Add health
# TODO: Add coyote jumping				 # Done!
# TODO: Refactor code to new system 	 # Done!
# TODO: Move to new system				 # Done!

func _ready():
	$nd_ground_check.position.y = -base_scale.y - 0.4

func _physics_process(delta):
	get_viewport().get_camera_3d().get_node("nd_ui/nd_gui/nd_health_container").displayed_points = health
	
	var move_vector = Vector2(
		Input.get_axis("move_right", "move_left"),
		Input.get_axis("move_foward", "move_down")
		)
		
	if (move_vector.x != 0 || move_vector.y != 0):
		if get_viewport().get_camera_3d() != null:
			force = Vector2(
				(-move_vector.y * -get_viewport().get_camera_3d().transform.basis.z.x) + -move_vector.x * get_viewport().get_camera_3d().transform.basis.x.x, 
				(-move_vector.y * -get_viewport().get_camera_3d().transform.basis.z.z) + -move_vector.x * get_viewport().get_camera_3d().transform.basis.x.z
				)
			force = force.normalized()
	if Input.is_action_just_pressed("move_crouch"):
		if crouching:
			$nd_ground_check.position.y = crouch_scale - 0.4
			$CollisionShape3D.scale.y = crouch_scale
			crouching = false 
		elif !crouching && can_get_up:
			$nd_ground_check.position.y = -base_scale.y - 0.4
			position.y += base_scale.y / 2
			$CollisionShape3D.scale.y = base_scale.y
			crouching = true
		
	match ground_state:
		GROUND_STATES.IDLE:
			if positional_state == POSITIONAL_STATES.ON_GROUND:
				_velocity.x -= _velocity.x * ground_friction * delta
				_velocity.z -= _velocity.z * ground_friction * delta
			else:
				_velocity.x -= _velocity.x * air_friction * delta
				_velocity.z -= _velocity.z * air_friction * delta

			if move_vector.length() != 0:
				ground_state = GROUND_STATES.MOVING

		GROUND_STATES.MOVING:
			if positional_state == POSITIONAL_STATES.ON_GROUND:
				_velocity.x -= _velocity.x * ground_grip * delta
				_velocity.z -= _velocity.z * ground_grip * delta
				
				_velocity.x += force.x * (speed * ground_grip) * delta
				_velocity.z += force.y * (speed * ground_grip) * delta
			else:
				_velocity.x -= _velocity.x * air_grip * delta
				_velocity.z -= _velocity.z * air_grip * delta

				_velocity.x += force.x * 25 * delta
				_velocity.z += force.y * 25 * delta

			if move_vector.length() == 0:
				ground_state = GROUND_STATES.IDLE

	match positional_state:
		POSITIONAL_STATES.ON_GROUND:
			jump_y = 0
			coyote_timer = 0
			
			if Input.is_action_just_pressed("move_jump"):
				jump_y += jump_force
				positional_state = POSITIONAL_STATES.JUMPING
			
			if !is_on_ground:
				positional_state = POSITIONAL_STATES.FALLING
		
		POSITIONAL_STATES.FALLING:
			
			jump_y -= gravity
			
			if coyote_timer <= coyote_timer_max:
				coyote_timer += delta
				if Input.is_action_just_pressed("move_jump"):
					jump_y = 0
					jump_y += jump_force
					positional_state = POSITIONAL_STATES.JUMPING
				
			if is_on_ground || is_on_floor():
				positional_state = POSITIONAL_STATES.ON_GROUND
						
		POSITIONAL_STATES.JUMPING:
			
			jump_y -= gravity
			
			# if is_on_ceiling():
			# 	jump_y -= jump_force / 2
			
			if jump_y < 0:
				coyote_timer = coyote_timer_max + 10
				positional_state = POSITIONAL_STATES.FALLING


	#_velocity.x = force.x * speed * delta
	#_velocity.z = force.y * speed * delta
	
	_velocity.y = jump_y * delta
	
	set_velocity(_velocity)
	set_up_direction(Vector3.UP)
	
	move_and_slide()


func _on_nd_ground_check_body_entered(body):
	if body != self:
		is_on_ground = true


func _on_nd_ground_check_body_exited(body):
	if body != self:
		is_on_ground = false


func _on_nd_height_check_body_entered(body):
	if body != self:
		can_get_up = false


func _on_nd_height_check_body_exited(body):
	if body != self:
		can_get_up = true
