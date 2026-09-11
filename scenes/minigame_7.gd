extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var keyOne: TextureButton = $BongoKey1
@onready var keyTwo: TextureButton = $BongoKey2

@onready var leftSound: AudioStreamPlayer2D = $Left
@onready var rightSound: AudioStreamPlayer2D = $Right

@onready var instructions: ColorRect = $InstructionBg

var stepOne = false
var stepTwo = false
var stepThree = false
var stepFour = false
var endGame = false

var timer_end = false

var keyOnePressed = false
var keyTwoPressed = false

var start = false

var won = false

var key_cooldown := 0.0
const KEY_COOLDOWN_TIME := .25


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if key_cooldown > 0.0:
		key_cooldown -= delta

	if start:
		start = false
		instructions.hide()
		keyOne.modulate = Color(0.373, 1.0, 0.537, 1.0)
		await themed_timer.Timer(6.0)
		#after this is completed...
		timer_end = true 
	
	keyOnePressed = Input.is_action_pressed("q")
	keyTwoPressed = Input.is_action_pressed("e")

	_keys()
		
	if (won == true):
		won = false
		Global.won = true
		await get_tree().create_timer(.5).timeout
		Transition.change_scene_to_file("res://scenes/done_screen.tscn")
	
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
	if key_cooldown > 0.0:
		return

	if (keyOnePressed):
		leftSound.play()
	if (keyTwoPressed):
		rightSound.play()

		
	if keyOnePressed && !keyTwoPressed && !endGame && !stepOne && !stepTwo && !stepThree:
		keyTwo.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyOne.modulate = Color(1.0, 1.0, 1.0, 1.0)
		keyOnePressed = false
		keyTwoPressed = false
		stepOne = true
		key_cooldown = KEY_COOLDOWN_TIME
		return

	if keyTwoPressed && !keyOnePressed && stepOne && !endGame:
		keyTwo.modulate = Color(1, 1, 1, 1)
		keyOne.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyOnePressed = false
		keyTwoPressed = false
		stepOne = false
		stepTwo = true
		key_cooldown = KEY_COOLDOWN_TIME
		return

	if keyOnePressed && !keyTwoPressed && stepTwo && !endGame:
		keyOne.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyTwo.modulate = Color(1, 1, 1, 1)
		keyOnePressed = false
		keyTwoPressed = false
		stepTwo = false
		stepThree = true
		key_cooldown = KEY_COOLDOWN_TIME
		return

	if !keyTwoPressed && keyOnePressed && stepThree && !endGame:
		keyOne.modulate = Color(1.0, 1.0, 1.0, 1.0)
		keyTwo.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyOnePressed = false
		keyTwoPressed = false

		stepThree = false 
		stepFour = true
		key_cooldown = KEY_COOLDOWN_TIME
		return

		
	if keyTwoPressed && !keyOnePressed && stepFour && !endGame:
		keyOne.modulate = Color(1.0, 1.0, 1.0, 1.0)
		keyTwo.modulate = Color(1.0, 1.0, 1.0, 1.0)
		keyOnePressed = false
		keyTwoPressed = false

		stepFour = false 
		won = true
		endGame = true
		return

func _on_start_pressed() -> void:
	start = true
	
func _on_bongo_key_1_pressed() -> void:
	keyOnePressed = true

func _on_bongo_key_2_pressed() -> void:
	keyTwoPressed = true
