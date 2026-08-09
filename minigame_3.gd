extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var info: RichTextLabel = $RichTextLabel

var buttons_pressed := 0
var timer_end = false
var rng = RandomNumberGenerator.new()
var random_number = rng.randf_range(0, 2.0)

func _ready() -> void:
	await themed_timer.Timer(5.0)
	#after this is completed...
	timer_end = true 


func _process(delta: float) -> void:
	if random_number > 1.5: 
		info.text = "SHARP! 
TUNE DOWN! 
(SPAM 20)"
	else:
		info.text = "FLAT!
TUNE UP! (SPAM 20)"
	if buttons_pressed == 10:
		var new_texture = preload("res://assets/eh.png")
		$Face.set_texture(new_texture)
	if buttons_pressed == 18:
		var new_texture = preload("res://assets/happy.png")
		$Face.set_texture(new_texture)

	
	if buttons_pressed == 20:
		#Global.minigames_done += 1
		get_tree().change_scene_to_file("res://scenes/level_scene.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission
