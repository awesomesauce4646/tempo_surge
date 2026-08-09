extends TextureButton

@onready var parent = $".."

func _on_pressed() -> void: #YOU NEED TO CONNECT THIS SIGNAL FROM THE TAB NEXT TO INSPECTOR!!
	if parent.random_number < 1.5:
		parent.buttons_pressed += 1
	else:
		parent.buttons_pressed -= 1
