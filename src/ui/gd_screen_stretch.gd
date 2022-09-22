extends Container


func _ready():
	offset_right = get_viewport().size.x
	offset_bottom = get_viewport().size.y

	for children in get_children():
		children.offset_right = get_viewport().size.x
		children.offset_bottom = get_viewport().size.y
