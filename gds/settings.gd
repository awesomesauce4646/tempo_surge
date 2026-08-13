extends Node2D

@onready var musicButton: TextureButton = $MusicToggle

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

var is_muted: bool = false
var onOrOff: String = "ON"

func _on_music_toggle_pressed() -> void:
	var off = preload("res://assets/music_off.png.png.png")
	var on = preload("res://assets/music_on.png.png")
	
	is_muted = !is_muted 
	GlobalMusic.stream_paused = is_muted
	
	if onOrOff == "OFF":
		onOrOff = "ON"
		musicButton.texture_normal = off  # Line 26: Must use .texture_normal
	else:
		onOrOff = "OFF"
		musicButton.texture_normal = on   # Line 22: Must use .texture_normal
