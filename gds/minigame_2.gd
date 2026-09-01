extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var noteOne: TextureButton = $Button_1
@onready var noteTwo: TextureButton = $Button_2
@onready var noteThree: TextureButton = $Button_3
@onready var noteFour: TextureButton = $Button_4
@onready var instructions: ColorRect = $InstructionBg

var buttons_pressed := 0
var timer_end = false

var rng = RandomNumberGenerator.new()
var start = false

func _ready():
	pass
	



func _process(delta: float) -> void:
	if start: 
		start = false
		rng.randomize()
		instructions.hide()
		noteOne.show()
		noteTwo.show()
		noteThree.show()
		noteFour.show()
		await themed_timer.Timer(4)
		#after this is completed...
		timer_end = true 
		
	
	if buttons_pressed == 4:
		if Global.minigames_done > 3:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			Global.won = true
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _on_start_pressed() -> void:
	start = true
