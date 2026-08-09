extends Node2D

@onready var button: Button = $Back

func _on_back_pressed() -> void:
	Global.minigames_done = 0 #track how many minigames done
	Global.lives = 5 #track how many lives left, also effecting garlic appearing
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
