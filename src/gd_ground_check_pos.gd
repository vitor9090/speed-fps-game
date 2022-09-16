extends Spatial

func _ready():
	set_as_toplevel(true)
	
func _process(delta):
	translation = Vector3(get_parent().translation.x, get_parent().translation.y - get_parent().find_node('CollisionShape').scale.y + 0.7, get_parent().translation.z)
