extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var keyOne: TextureButton = $TrumpetKey1
@onready var keyTwo: TextureButton = $TrumpetKey2
@onready var keyThree: TextureButton = $TrumpetKey3
@onready var gNote: AudioStreamPlayer2D = $G
@onready var bNote: AudioStreamPlayer2D = $B
@onready var cNote: AudioStreamPlayer2D = $C
@onready var dNote: AudioStreamPlayer2D = $D
@onready var wrongSound: AudioStreamPlayer2D = $WrongSound
@onready var textHi: RichTextLabel = $RichTextLabel
@onready var instructions: Panel = $InstructionBg

# each key is a bit: key1 = 1, key2 = 2, key3 = 4
# the sequence: G (key1 + key3 together), B (key2), D (key1), C (key3)
const EXPECTED := [5, 2, 1, 4]
const CHORD_MS := 50 # two keys within this many ms count as one chord
const C_START := 0.55 # skips the silence at the start of c_trumpet.mp3

var step := 0
var playing := false
var prev_held := 0
var chord_mask := 0
var chord_timer := 0.0
var down_ms := [0, 0, 0] # when each key last went down
var mouse_held := 0 # keys currently held by mouse click

var endGame = false
var timer_end = false
var start = false
var won = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if start:
		start = false
		playing = true
		instructions.hide()
		_update_highlights()
		await themed_timer.Timer(6.0 + Global.extra_time)
		#after this is completed...
		timer_end = true

	if playing:
		_read_input(delta) # stays on after the win so players can jam during the celebration

	if (won == true):
		won = false
		textHi.text = "HUZZAH! GO WILD!"
		await get_tree().create_timer(3).timeout
		Global.won = true
		Transition.change_scene_to_file("res://scenes/level_scene.tscn")

	if timer_end and not endGame:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		timer_end = false

		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn")
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _held_mask() -> int:
	var m := 0
	if Input.is_action_pressed("key_one") or (mouse_held & 1) != 0:
		m |= 1
	if Input.is_action_pressed("key_two") or (mouse_held & 2) != 0:
		m |= 2
	if Input.is_action_pressed("key_three") or (mouse_held & 4) != 0:
		m |= 4
	return m


func _read_input(delta: float) -> void:
	var held := _held_mask()
	var just_down := held & ~prev_held
	prev_held = held

	var now := Time.get_ticks_msec()
	for i in range(3):
		if (just_down & (1 << i)) != 0:
			down_ms[i] = now

	# --- sound: plays the instant a key goes down ---
	var is_chord: bool = (just_down & 5) != 0 and (held & 5) == 5 and abs(down_ms[0] - down_ms[2]) <= CHORD_MS
	if is_chord:
		dNote.stop()
		cNote.stop()
		gNote.play()
	else:
		if (just_down & 1) != 0:
			dNote.play()
		if (just_down & 4) != 0:
			cNote.play(C_START)
	if (just_down & 2) != 0:
		bNote.play()

	# --- judging: only keys pressed just now, within a short window ---
	if just_down != 0:
		chord_mask |= just_down
		if chord_timer <= 0.0:
			chord_timer = CHORD_MS / 1000.0

	if chord_timer > 0.0:
		chord_timer -= delta
		if chord_timer <= 0.0:
			_judge_combo(chord_mask)
			chord_mask = 0


func _judge_combo(mask: int) -> void:
	if endGame:
		return # celebration: free play, no judging

	if mask == EXPECTED[step]:
		step += 1
		if step >= EXPECTED.size():
			won = true
			endGame = true
		_update_highlights()
	else:
		wrongSound.play() # plays on top of the note


func _update_highlights() -> void:
	var green := Color(0.373, 1.0, 0.537, 1.0)
	var keys := [keyOne, keyTwo, keyThree]
	var want: int = EXPECTED[step] if step < EXPECTED.size() else 0
	for i in range(3):
		keys[i].modulate = green if (want & (1 << i)) != 0 else Color.WHITE


func _on_trumpet_key_1_button_down() -> void:
	mouse_held |= 1

func _on_trumpet_key_1_button_up() -> void:
	mouse_held &= ~1


func _on_trumpet_key_2_button_down() -> void:
	mouse_held |= 2

func _on_trumpet_key_2_button_up() -> void:
	mouse_held &= ~2


func _on_trumpet_key_3_button_down() -> void:
	mouse_held |= 4

func _on_trumpet_key_3_button_up() -> void:
	mouse_held &= ~4


func _on_start_pressed() -> void:
	start = true
