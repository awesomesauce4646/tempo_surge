extends Node2D

@onready var musicButton: TextureButton = $MusicToggle
@onready var chillButton: TextureButton = $ChillMode

func _on_back_pressed() -> void:
	Transition.change_scene_to_file("res://scenes/title_screen.tscn")

var is_muted: bool = false
var onOrOff: String = "ON"
var chillOrNormal: String = "NORMAL"

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



func _on_chill_mode_pressed() -> void:
	var chill = preload("res://assets/chill_tempo.png")
	var normal = preload("res://assets/normal_mode_tempo.png")
	
	if chillOrNormal == "CHILL":
		chillOrNormal = "NORMAL"
		chillButton.texture_normal = chill      # Uses the preloaded texture!
		Global.extra_time = 0.0                 # Sets the extra time buffer
	else:
		chillOrNormal = "CHILL"
		chillButton.texture_normal = normal     # Uses the preloaded texture!
		Global.extra_time = 4.0
