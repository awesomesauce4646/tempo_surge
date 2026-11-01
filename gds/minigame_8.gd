extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var instructions: TextureRect = $InstructionBg
@onready var firstNote: TextureButton = $C
@onready var secondNote: TextureButton = $D
@onready var thirdNote: TextureButton = $A
@onready var fourthNote: TextureButton = $G
@onready var firstText: RichTextLabel = $CText
@onready var secondText: RichTextLabel = $DText
@onready var thirdText: RichTextLabel = $AText
@onready var fourthText: RichTextLabel = $GText
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var wrongSound: AudioStreamPlayer2D = $SoundWrong
@onready var gif: AnimatedSprite2D = $InstructionBg/GifBackground/InstructionsGif
@onready var instructionText: RichTextLabel = $InstructionBg/Instructions
@onready var gifButton: TextureButton = $InstructionBg/GifButton
@onready var gifBackground: TextureRect = $InstructionBg/GifBackground

var gifOpened = false

const FADE_TIME := 0.4

# every letter that counts as a note press
const NOTE_KEYS := {
	KEY_A: "A", KEY_B: "B", KEY_C: "C", KEY_D: "D",
	KEY_E: "E", KEY_F: "F", KEY_G: "G",
}

# the order the player has to type
var sequence := ["C", "D", "A", "G"]
var step := 0
var input_open := false # true once the notes have faded and typing starts

var endGame = false
var timer_end = false
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
		if Global.extra_time > 0:
			await themed_timer.Timer(0 + Global.extra_time)
		else:
			await themed_timer.Timer(3 + Global.extra_time)
		#after this is completed...
		await _fade_out_notes()
		input_open = true
		await themed_timer.Timer(6.0 + Global.extra_time)
		timer_end = true

	if (won == true):
		won = false
		Global.won = true
		Transition.change_scene_to_file("res://scenes/level_scene.tscn") # go back to the intermission scene

	if timer_end and not endGame:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		timer_end = false

		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn")
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _input(event: InputEvent) -> void:
	if not input_open or endGame:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var letter = NOTE_KEYS.get(event.keycode)
		if letter != null:
			_play_note(letter)


func _play_note(letter: String) -> void:
	if letter == sequence[step]:
		_reveal(letter)
		sound.play()
		step += 1
		if step >= sequence.size():
			endGame = true
			won = true
	else:
		wrongSound.play() # wrong order, or a note that isn't in the song (B, E, F)


func _reveal(letter: String) -> void:
	match letter:
		"C": firstNote.show()
		"D": secondNote.show()
		"A": thirdNote.show()
		"G": fourthNote.show()


func _fade_out_notes() -> void:
	var items = [
		firstNote, secondNote, thirdNote, fourthNote,
		firstText, secondText, thirdText, fourthText,
	]
	var tween := create_tween().set_parallel(true)
	for item in items:
		tween.tween_property(item, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	for item in items:
		item.hide()
		item.modulate.a = 1.0 # reset so show() works later when the player types it


func _on_start_pressed() -> void:
	start = true


# kept so the scene's signal connections don't break; typing is handled in _input
func _on_c_pressed() -> void:
	pass

func _on_d_pressed() -> void:
	pass

func _on_a_pressed() -> void:
	pass

func _on_g_pressed() -> void:
	pass


func _on_gif_button_pressed() -> void:
	if gifOpened == false:
		gif.play("default")
		gifBackground.show()
		gif.show()
		gifOpened = true
		instructionText.hide()
	else:
		gif.hide()
		gifBackground.hide()
		gifOpened = false
		instructionText.show()
