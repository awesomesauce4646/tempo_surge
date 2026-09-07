class_name SceneTransitionController
extends CanvasLayer

@export var background: ColorRect
@export var animation_player: AnimationPlayer

func _ready() -> void:
	background.color.a = 0

func transition(animation: String, seconds: float) -> void:
	animation_player.play(animation, -1.0, 1.75 / seconds)

func change_scene_to_file(path: String, fade_time: float = 0.5) -> void:
	transition("Fade Out", fade_time)
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	transition("Fade In", fade_time)
