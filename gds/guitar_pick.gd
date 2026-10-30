extends Node2D
@onready var player: CharacterBody2D = $"../Player"
@onready var self_area = $Area2D
@onready var player_area = $"../Player/Area2D"
@onready var soundEffect = $"../PickUp"
@onready var anim: AnimationPlayer = $animation

signal note_collected

var collected := false
var start_scale := Vector2.ONE
var start_pos := Vector2.ZERO
var center := Vector2.ZERO

func _ready() -> void:
	anim.play("floating")
	anim.seek(randf() * anim.current_animation_length) # random start so the picks don't bob together

func _process(delta: float) -> void:
	if collected:
		return

	if player_area.overlaps_area(self_area):
		collected = true # set first, before any await, so this only runs once
		soundEffect.play()
		emit_signal("note_collected")
		self_modulate = Color(3.0, 3.0, 3.0, 1.0)
		await get_tree().create_timer(0.04).timeout

		center = _get_center()
		start_scale = scale
		start_pos = position

		var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_method(_shrink, 1.0, 0.0, 0.50)
		tween.tween_property(self, "self_modulate:a", 0.0, 0.15)
		await tween.finished
		hide()


# center of the collision circle, in this node's local space
func _get_center() -> Vector2:
	for child in self_area.get_children():
		if child is CollisionShape2D:
			return to_local(child.global_position)
	return Vector2.ZERO


func _shrink(k: float) -> void:
	scale = start_scale * k
	# shift position so the center stays in the same spot while scaling
	position = start_pos + (start_scale - scale) * center
