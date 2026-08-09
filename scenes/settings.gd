extends Node2D

@onready var musicButton: Button = $MusicToggle

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

var is_muted: bool = false
var onOrOff: String = "ON";

func _on_music_toggle_pressed() -> void:

		is_muted = !is_muted # Flip the true/false value
		GlobalMusic.stream_paused = is_muted
		musicButton.text = "TURN MUSIC " + onOrOff
		if (onOrOff == "OFF"):
			onOrOff = "ON"
		else:
			onOrOff ="OFF"
