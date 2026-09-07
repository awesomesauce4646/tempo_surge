extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var keyOne: TextureButton = $TrumpetKey1
@onready var keyTwo: TextureButton = $TrumpetKey2
@onready var keyThree: TextureButton = $TrumpetKey3
@onready var gNote: AudioStreamPlayer2D = $G
@onready var bNote: AudioStreamPlayer2D = $B
@onready var cNote: AudioStreamPlayer2D = $C
@onready var dNote: AudioStreamPlayer2D = $D
@onready var textHi: RichTextLabel = $RichTextLabel
@onready var instructions: ColorRect = $InstructionBg

var stepOne = false
var stepTwo = false
var stepThree = false
var endGame = false

var timer_end = false

var keyOnePressed = false
var keyTwoPressed = false
var keyThreePressed = false

var start = false

var won = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if start:
		start = false
		instructions.hide()
		keyOne.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyThree.modulate = Color(0.373, 1.0, 0.537, 1.0)
		await themed_timer.Timer(6.0)
		#after this is completed...
		timer_end = true 
	
	keyOnePressed = Input.is_action_pressed("key_one")
	keyTwoPressed = Input.is_action_pressed("key_two")
	keyThreePressed = Input.is_action_pressed("key_three")
	print("1:", keyOnePressed, " 2:", keyTwoPressed, " 3:", keyThreePressed)
	_keys()
		
	if (won == true):
		won = false
		textHi.text = "HUZZAH! GO WILD!"
		await get_tree().create_timer(3).timeout
		Global.won = true
		Transition.change_scene_to_file("res://scenes/done_screen.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission

func _keys() -> void:
	
	if (keyOnePressed && keyThreePressed):
		gNote.play()
	if (keyTwoPressed):
		bNote.play()
	if(keyOnePressed):
		dNote.play()
	if(keyThreePressed):
		cNote.play()
		
	if keyOnePressed && keyThreePressed && !keyTwoPressed && !endGame:
		keyTwo.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyOne.modulate = Color(1.0, 1.0, 1.0, 1.0)
		keyThree.modulate = Color(1, 1, 1, 1)
		keyOnePressed = false
		keyTwoPressed = false
		keyThreePressed = false
		stepOne = true
		return

	if keyTwoPressed && !keyOnePressed && !keyThreePressed && stepOne && !endGame:
		keyTwo.modulate = Color(1, 1, 1, 1)
		keyOne.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyOnePressed = false
		keyTwoPressed = false
		keyThreePressed = false
		stepOne = false
		stepTwo = true
		return

	if keyOnePressed && !keyTwoPressed && !keyThreePressed && stepTwo && !endGame:
		keyOne.modulate = Color(1, 1, 1, 1)
		keyTwo.modulate = Color(1,1,1,1)
		keyThree.modulate = Color(0.373, 1.0, 0.537, 1.0)
		keyOnePressed = false
		keyTwoPressed = false
		keyThreePressed = false
		stepTwo = false
		stepThree = true
		return

	if !keyTwoPressed && keyThreePressed && !keyOnePressed && stepThree && !endGame:
		keyOne.modulate = Color(1.0, 1.0, 1.0, 1.0)
		keyThree.modulate = Color(1, 1, 1, 1)
		keyTwo.modulate = Color(1,1,1,1)
		keyOnePressed = false
		keyTwoPressed = false
		keyThreePressed = false
		stepThree = false # sequence fully complete, ready to start again
		won = true
		endGame = true



func _on_trumpet_key_1_button_down() -> void:
	keyOnePressed = true


func _on_trumpet_key_1_button_up() -> void:
	keyOnePressed = false


func _on_trumpet_key_2_button_down() -> void:
	keyTwoPressed = true

func _on_trumpet_key_2_button_up() -> void:
	keyTwoPressed = false


func _on_trumpet_key_3_button_down() -> void:
	keyThreePressed = true


func _on_trumpet_key_3_button_up() -> void:
	keyThreePressed = false


func _on_start_pressed() -> void:
	start = true
