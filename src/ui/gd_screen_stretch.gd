extends Container


func _ready():
	margin_right = get_viewport().size.x
	margin_bottom = get_viewport().size.y

	for children in get_children():
		children.margin_right = get_viewport().size.x
		children.margin_bottom = get_viewport().size.y
