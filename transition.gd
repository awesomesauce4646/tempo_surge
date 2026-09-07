extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

func change_scene(path: String) -> void:
	anim.play("Fade Out")
	await anim.animation_finished
	get_tree().change_scene_to_file(path)
	anim.play("Fade In")
