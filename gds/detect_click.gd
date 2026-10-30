extends TextureButton
@onready var parent = $".."

func _ready() -> void:
	pivot_offset = size / 2
	position = Vector2(
		parent.rng.randf_range(0.0, 950.0),
		parent.rng.randf_range(0.0, 420.0)
	)

func _on_pressed() -> void: #YOU NEED TO CONNECT THIS SIGNAL FROM THE TAB NEXT TO INSPECTOR!!
	parent.buttons_pressed += 1	
	self_modulate = Color(3.0, 3.0, 3.0, 1.0) # Super bright white-out flash
	await get_tree().create_timer(0.04).timeout
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", scale * 1.5, 0.15)       # Pop larger
	tween.tween_property(self, "self_modulate:a", 0.0, 0.15)     # Fade out alpha
	await tween.finished
	hide()
	queue_free()
