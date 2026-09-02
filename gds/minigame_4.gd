extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var x1: TextureButton = $Three
@onready var x2: TextureButton = $Four
@onready var x3: TextureButton = $One
@onready var x4: TextureButton = $Two
@onready var x5: TextureButton = $Eight
@onready var x6: TextureButton = $Seven
@onready var x7: TextureButton = $Six
@onready var x8: TextureButton = $Five
@onready var instructions: ColorRect = $InstructionBg

var start = false
var timer_end = false
var selected: TextureButton = null
var pairs = []
var swapped_state = {} # pair_index -> bool (true = currently swapped)
var correct_swapped = {} # pair_index -> bool (what "solved" means for that pair)

func _ready() -> void:
	pairs = [
		[x1, x3],
		[x2, x4],
		[x5, x8],
		[x6, x7],
	]

	# Each pair currently starts in its scrambled (wrong) state.
	# "correct_swapped" says whether the pair needs to be SWAPPED to be right.
	# Since they're all currently wrong, solving = swapping every pair once.
	for i in range(pairs.size()):
		swapped_state[i] = false
		correct_swapped[i] = true

	for btn in [x1, x2, x3, x4, x5, x6, x7, x8]:
		btn.pressed.connect(_on_button_pressed.bind(btn))



func _process(delta: float) -> void:
	if start: 
		start = false
		instructions.hide()
		await themed_timer.Timer(6.0)
		timer_end = true
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -= 1
		Global.won = false
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://scenes/lost_game.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn")

func _on_button_pressed(btn: TextureButton) -> void:
	if selected == null:
		selected = btn
		selected.modulate = Color(1.3, 1.3, 1.3)
		return

	if selected == btn:
		selected.modulate = Color(1, 1, 1)
		selected = null
		return

	var pair_index = _get_pair_index(selected, btn)
	if pair_index != -1:
		_swap_positions(selected, btn)
		swapped_state[pair_index] = !swapped_state[pair_index]
		_check_win()

	selected.modulate = Color(1, 1, 1)
	selected = null

func _get_pair_index(a: TextureButton, b: TextureButton) -> int:
	for i in range(pairs.size()):
		if (pairs[i][0] == a and pairs[i][1] == b) or (pairs[i][0] == b and pairs[i][1] == a):
			return i
	return -1

func _swap_positions(a: TextureButton, b: TextureButton) -> void:
	var center_a = a.position + a.size / 2
	var center_b = b.position + b.size / 2
	a.position = center_b - a.size / 2
	b.position = center_a - b.size / 2

func _check_win() -> void:
	for i in range(pairs.size()):
		if swapped_state[i] != correct_swapped[i]:
			return
	_on_win()

func _on_win() -> void:
	Global.won = true
	get_tree().change_scene_to_file("res://scenes/level_scene.tscn")


func _on_start_pressed() -> void:
	start = true
