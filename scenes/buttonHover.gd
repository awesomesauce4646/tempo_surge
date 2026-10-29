extends TextureButton

@export var normal_color: Color = Color(1, 1, 1, 1)
@export var hover_color: Color = Color(1.108, 1.133, 1.2, 1.0) 
@export var animation_speed: float = 0.15

var original_scale: Vector2

func _ready() -> void:
	self_modulate = normal_color
	original_scale = scale # Save the default size on start!
	pivot_offset = size / 2 
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "self_modulate", hover_color, animation_speed)
	tween.tween_property(self, "scale", original_scale * 1.075, animation_speed)    

func _on_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "self_modulate", normal_color, animation_speed)
	tween.tween_property(self, "scale", original_scale, animation_speed) # Snap back to original scale safely
