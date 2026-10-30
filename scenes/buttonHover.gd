extends TextureButton

@export var normal_color: Color = Color(1, 1, 1, 1)
@export var hover_color: Color = Color(1.108, 1.133, 1.2, 1.0)
@export var animation_speed: float = 0.15
@export var wobble_angle: float = 0.06 # radians, keep small for subtle

var original_scale: Vector2
var original_rotation: float
var style_tween: Tween
var wobble_tween: Tween

func _ready() -> void:
	self_modulate = normal_color
	original_scale = scale # Save the default size on start!
	original_rotation = rotation
	pivot_offset = size / 2
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	# Color + scale together
	if style_tween:
		style_tween.kill()
	style_tween = create_tween().set_parallel(true)
	style_tween.tween_property(self, "self_modulate", hover_color, animation_speed)
	style_tween.tween_property(self, "scale", original_scale * 1.075, animation_speed)

	# Wobble back and forth, settling down (sequential steps)
	if wobble_tween:
		wobble_tween.kill()
	wobble_tween = create_tween()
	wobble_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wobble_tween.tween_property(self, "rotation", original_rotation + wobble_angle, animation_speed)
	wobble_tween.tween_property(self, "rotation", original_rotation - wobble_angle * 0.7, animation_speed)
	wobble_tween.tween_property(self, "rotation", original_rotation + wobble_angle * 0.4, animation_speed)
	wobble_tween.tween_property(self, "rotation", original_rotation, animation_speed)

func _on_mouse_exited() -> void:
	if style_tween:
		style_tween.kill()
	style_tween = create_tween().set_parallel(true)
	style_tween.tween_property(self, "self_modulate", normal_color, animation_speed)
	style_tween.tween_property(self, "scale", original_scale, animation_speed)

	# Stop any wobble in progress and ease back to rest
	if wobble_tween:
		wobble_tween.kill()
	wobble_tween = create_tween()
	wobble_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	wobble_tween.tween_property(self, "rotation", original_rotation, animation_speed)
