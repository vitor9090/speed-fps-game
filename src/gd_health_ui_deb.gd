extends Label

var percent:float = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			percent += .1
		elif event.button_index == BUTTON_WHEEL_DOWN:
			percent -= .1
		percent = clamp(percent, 0, 1)
		percent_visible = percent
