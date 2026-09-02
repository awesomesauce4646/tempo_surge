extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var stringOne: TextureRect = $String1
@onready var stringTwo: TextureRect = $String2
@onready var stringThree: TextureRect = $String3
@onready var pointOne: TextureButton = $PointOne
@onready var pointTwo: TextureButton = $PointTwo
@onready var pointThree: TextureButton = $PointThree
@onready var pointFour: TextureButton = $PointFour
@onready var pointFive: TextureButton = $PointFive
@onready var pointSix: TextureButton = $PointSix
@onready var instructions: ColorRect = $InstructionBg

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

var start = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if start:
		start = false
		instructions.hide()
		await themed_timer.Timer(5.0)
		#after this is completed...
		timer_end = true 

	_string_strung()
	if strungOne && strungTwo && strungThree == true:
		Global.won = true
		get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
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
	if (pointOneClick == true):
		pointOne.modulate = Color(0.373, 1.0, 0.537, 1.0)
		pointThree.modulate = Color(1,1,1,1)
		pointFour.modulate = Color(1,1,1,1)
		pointFive.modulate = Color(1,1,1,1)
		pointSix.modulate = Color(1,1,1,1)
	else:
		pointOne.modulate = Color(1,1,1,1)
	pointThreeClick = false
	pointFourClick = false
	pointFiveClick = false
	pointSixClick = false


func _on_point_two_pressed() -> void:
	pointTwoClick = !pointTwoClick
	if (pointTwoClick == true):
		pointTwo.modulate = Color(0.373, 1.0, 0.537, 1.0)
		pointThree.modulate = Color(1,1,1,1)
		pointFour.modulate = Color(1,1,1,1)
		pointFive.modulate = Color(1,1,1,1)
		pointSix.modulate = Color(1,1,1,1)
	else:
		pointTwo.modulate = Color(1,1,1,1)
	pointThreeClick = false
	pointFourClick = false
	pointFiveClick = false
	pointSixClick = false


func _on_point_three_pressed() -> void:
	pointThreeClick = !pointThreeClick
	if (pointThreeClick == true):
		pointThree.modulate = Color(0.373, 1.0, 0.537, 1.0)
		pointOne.modulate = Color(1,1,1,1)
		pointTwo.modulate = Color(1,1,1,1)
		pointFive.modulate = Color(1,1,1,1)
		pointSix.modulate = Color(1,1,1,1)
	else:
		pointThree.modulate = Color(1,1,1,1)
	pointOneClick = false
	pointTwoClick = false
	pointFiveClick = false
	pointSixClick = false

func _on_point_four_pressed() -> void:
	pointFourClick = !pointFourClick
	if (pointFourClick == true):
		pointFour.modulate = Color(0.373, 1.0, 0.537, 1.0)
		pointOne.modulate = Color(1,1,1,1)
		pointTwo.modulate = Color(1,1,1,1)
		pointFive.modulate = Color(1,1,1,1)
		pointSix.modulate = Color(1,1,1,1)
	else:
		pointFour.modulate = Color(1,1,1,1)
	pointOneClick = false
	pointTwoClick = false
	pointFiveClick = false
	pointSixClick = false


func _on_point_five_pressed() -> void:
	pointFiveClick = !pointFiveClick
	if (pointFiveClick == true):
		pointFive.modulate = Color(0.373, 1.0, 0.537, 1.0)
		pointOne.modulate = Color(1,1,1,1)
		pointTwo.modulate = Color(1,1,1,1)
		pointFour.modulate = Color(1,1,1,1)
		pointThree.modulate = Color(1,1,1,1)
	else:
		pointFive.modulate = Color(1,1,1,1)
	pointOneClick = false
	pointTwoClick = false
	pointThreeClick = false
	pointFourClick = false


func _on_point_six_pressed() -> void:
	pointSixClick = !pointSixClick
	if (pointSixClick == true):
		pointSix.modulate = Color(0.373, 1.0, 0.537, 1.0)
		pointOne.modulate = Color(1,1,1,1)
		pointTwo.modulate = Color(1,1,1,1)
		pointFour.modulate = Color(1,1,1,1)
		pointThree.modulate = Color(1,1,1,1)
	else:
		pointSix.modulate = Color(1,1,1,1)
	pointOneClick = false
	pointTwoClick = false
	pointThreeClick = false
	pointFourClick = false


func _on_start_pressed() -> void:
	start = true
