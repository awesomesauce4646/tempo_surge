extends TextureButton

@onready var parent = $".."
@onready var wrongSound = $WrongSound
@onready var rightSound = $RightSound

@export var is_down := false
@export var hover_scale := 1.1
@export var hover_color := Color(1.2, 1.2, 1.3, 1)
@export var anim_speed := 0.15

var captured := false
var base_scale := Vector2.ONE
var center := Vector2.ZERO  # the arrow's middle, in parent space, stays put
var zoom := 1.0
var tween: Tween
var shake_tween: Tween
var shake_x := 0.0

func _ready() -> void:
	mouse_entered.connect(_hover.bind(true))
	mouse_exited.connect(_hover.bind(false))

func _capture() -> void:
	# Done on first hover so size/scale are final by then
	if captured:
		return
	captured = true
	base_scale = scale
	center = position + (size / 2 * base_scale).rotated(rotation)

func _hover(hovering: bool) -> void:
	_capture()
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	var target_zoom := hover_scale if hovering else 1.0
	tween.tween_method(_set_zoom, zoom, target_zoom, anim_speed)
	tween.tween_property(self, "self_modulate", hover_color if hovering else Color.WHITE, anim_speed)

func _set_zoom(z: float) -> void:
	zoom = z
	var s := base_scale * z
	scale = s
	position = center - (size / 2 * s).rotated(rotation) + Vector2(shake_x, 0)

func _set_shake(x: float) -> void:
	shake_x = x
	position = center - (size / 2 * scale).rotated(rotation) + Vector2(shake_x, 0)

func _shake() -> void:
	wrongSound.play()
	_capture()
	if shake_tween:
		shake_tween.kill()
	shake_tween = create_tween()
	shake_tween.tween_method(_set_shake, 0.0, 8.0, 0.04)
	shake_tween.tween_method(_set_shake, 8.0, -8.0, 0.08)
	shake_tween.tween_method(_set_shake, -8.0, 6.0, 0.08)
	shake_tween.tween_method(_set_shake, 6.0, 0.0, 0.04)

func _on_pressed() -> void:
	var before = parent.buttons_pressed
	var step := -1 if is_down else 1
	if parent.random_number < 1:
		parent.buttons_pressed -= step
	else:
		parent.buttons_pressed += step
	if parent.buttons_pressed < before:
		_shake()
	else:
		rightSound.play()
