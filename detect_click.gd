extends TextureButton

@onready var parent = $".."

var rng = RandomNumberGenerator.new()
var x = rng.randf_range(0.0, 950.0)
var y = rng.randf_range(0.0, 420.0)

func _ready() -> void:
	position = Vector2(x,y)

func _on_pressed() -> void: #YOU NEED TO CONNECT THIS SIGNAL FROM THE TAB NEXT TO INSPECTOR!!
	hide()
	parent.buttons_pressed += 1
