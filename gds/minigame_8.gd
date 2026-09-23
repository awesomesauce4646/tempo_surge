extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var instructions: ColorRect = $InstructionBg
@onready var firstNote: TextureButton = $C
@onready var secondNote: TextureButton = $D
@onready var thirdNote: TextureButton = $A
@onready var fourthNote: TextureButton = $G
@onready var firstText: RichTextLabel = $CText
@onready var secondText: RichTextLabel = $DText
@onready var thirdText: RichTextLabel = $AText
@onready var fourthText: RichTextLabel = $GText


var stepOne = false
var stepTwo = false
var stepThree = false
var stepFour = false

var endGame = false

var timer_end = false

var cPressed = false
var dPressed = false
var aPressed = false
var gPressed = false

var start = false

var won = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if start:
		start = false
		instructions.hide()
		firstNote.show()
		secondNote.show()
		thirdNote.show()
		fourthNote.show()
		firstText.show()
		secondText.show()
		thirdText.show()
		fourthText.show()
		await themed_timer.Timer(1)
		#after this is completed...
		firstNote.hide()
		secondNote.hide()
		thirdNote.hide()
		fourthNote.hide()
		firstText.hide()
		secondText.hide()
		thirdText.hide()
		fourthText.hide()
		stepOne = true
		await themed_timer.Timer(3.0)
		timer_end = true 




	
	cPressed = Input.is_action_pressed("c")
	dPressed = Input.is_action_pressed("d")
	aPressed = Input.is_action_pressed("a")
	gPressed = Input.is_action_pressed("g")


	_keys()
		
	if (won == true):
		Global.won = true
		Transition.change_scene_to_file("res://scenes/level_scene.tscn") # go back to the intermission scene
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		timer_end = false

		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _keys() -> void:

		
	if cPressed && !dPressed && !aPressed && !gPressed && !endGame && stepOne && !stepTwo && !stepThree &&  !stepFour:
		firstNote.show()
		cPressed = false
		dPressed = false
		aPressed = false
		gPressed = false
		stepOne = false
		stepTwo = true
		return

	if !cPressed && dPressed && !aPressed && !gPressed && !endGame && !stepOne && stepTwo && !stepThree && !stepFour:
		secondNote.show()
		cPressed = false
		dPressed = false
		aPressed = false
		gPressed = false
		stepTwo = false
		stepThree = true
		return

	if !cPressed && !dPressed && aPressed && !gPressed && !endGame && !stepOne && !stepTwo && stepThree && !stepFour:
		thirdNote.show()
		cPressed = false
		dPressed = false
		aPressed = false
		gPressed = false
		stepThree = false
		stepFour = true
		return

	if !cPressed && !dPressed && !aPressed && gPressed && !endGame && !stepOne && !stepTwo && !stepThree && stepFour:
		fourthNote.show()
		cPressed = false
		dPressed = false
		aPressed = false
		gPressed = false
		stepFour = false
		won = true
		return

func _on_start_pressed() -> void:
	start = true


func _on_c_pressed() -> void:
	cPressed = true

func _on_d_pressed() -> void:
	dPressed = true

func _on_a_pressed() -> void:
	aPressed = true

func _on_g_pressed() -> void:
	gPressed = true
