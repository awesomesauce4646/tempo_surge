extends TextureButton
@onready var parent = $".."

func _ready() -> void:
	position = Vector2(
		parent.rng.randf_range(0.0, 950.0),
		parent.rng.randf_range(0.0, 420.0)
	)

func _on_pressed() -> void: #YOU NEED TO CONNECT THIS SIGNAL FROM THE TAB NEXT TO INSPECTOR!!
	hide()
	parent.buttons_pressed += 1
