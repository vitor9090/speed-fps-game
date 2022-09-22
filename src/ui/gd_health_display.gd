extends HBoxContainer

@export var displayed_points:int = 0

func _process(delta):
	for children in range(get_children().size()):
		if children < displayed_points:
			get_children()[children].visible = false
		else:
			get_children()[children].visible = true
