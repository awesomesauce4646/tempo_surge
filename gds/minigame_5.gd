extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var stringOne: TextureRect = $String1
@onready var stringTwo: TextureRect = $String2
@onready var stringThree: TextureRect = $String3

var timer_end = false

var pointOneClick = false
var pointTwoClick = false
var pointThreeClick = false
var pointFourClick = false
var pointFiveClick = false
var pointSixClick = false

var strungOne = false
var strungTwo = false
var strungThree = false


func _ready() -> void:
	await themed_timer.Timer(8.0)
	#after this is completed...
	timer_end = true 


func _process(delta: float) -> void:


	_string_strung()
	if strungOne && strungTwo && strungThree == true:
		get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _string_strung() -> void: 
	if pointOneClick && pointTwoClick == true:
		strungOne = true
		stringOne.show()
	if pointThreeClick && pointFourClick == true:
		strungTwo = true
		stringTwo.show()
	if pointFiveClick && pointSixClick == true:
		strungThree = true
		stringThree.show()


func _on_point_one_pressed() -> void:
	pointOneClick = !pointOneClick
	pointThreeClick = false
	pointFourClick = false
	pointFiveClick = false
	pointSixClick = false


func _on_point_two_pressed() -> void:
	pointTwoClick = !pointTwoClick
	pointThreeClick = false
	pointFourClick = false
	pointFiveClick = false
	pointSixClick = false


func _on_point_three_pressed() -> void:
	pointThreeClick = !pointThreeClick
	pointOneClick = false
	pointTwoClick = false
	pointFiveClick = false
	pointSixClick = false

func _on_point_four_pressed() -> void:
	pointFourClick = !pointFourClick
	pointOneClick = false
	pointTwoClick = false
	pointFiveClick = false
	pointSixClick = false


func _on_point_five_pressed() -> void:
	pointFiveClick = !pointFiveClick
	pointOneClick = false
	pointTwoClick = false
	pointThreeClick = false
	pointFourClick = false


func _on_point_six_pressed() -> void:
	pointSixClick = !pointSixClick
	pointOneClick = false
	pointTwoClick = false
	pointThreeClick = false
	pointFourClick = false
