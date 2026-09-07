extends Node2D

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	Transition.change_scene_to_file("res://scenes/level_scene.tscn")

func _on_settings_pressed() -> void:
	Transition.change_scene_to_file("res://scenes/settings.tscn")

	
