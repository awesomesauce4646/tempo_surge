extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var info: RichTextLabel = $RichTextLabel
@onready var instructions: ColorRect = $InstructionBg

var buttons_pressed := 0
var timer_end = false
var rng = RandomNumberGenerator.new()
var random_number = rng.randf_range(0, 2.0)
var start = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if start:
		instructions.hide()
		start = false
		info.show()
		await themed_timer.Timer(5.0)
		#after this is completed...
		timer_end = true 
	
	if random_number > 1: 
		info.text = "SHARP! 
TUNE DOWN! 
(CLICK 20)"
	else:
		info.text = "FLAT!
TUNE UP! (CLICK 20)"
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


func _on_start_pressed() -> void:
	start = true
	pass # Replace with function body.
