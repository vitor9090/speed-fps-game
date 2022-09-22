extends Node3D

func _ready():
	set_as_top_level(true)
	
func _process(delta):
	position = Vector3(get_parent().position.x, get_parent().position.y - get_parent().find_child('CollisionShape3D').scale.y + 0.7, get_parent().position.z)
