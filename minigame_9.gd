extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var instructions: TextureRect = $InstructionBg
@onready var metronome: TextureRect = $Metronome
@onready var swing: TextureRect = $Swing
@onready var sound: AudioStreamPlayer2D = $MetronomeTick
@onready var wrongSound: AudioStreamPlayer2D = $WrongSound

const MAX_ANGLE := 28.0         
const BASE_SPEED := 4.0         
const SPEED_PER_HIT := 0.5      
const HIT_WINDOW := 7.0        
const HITS_TO_WIN := 3

const GOOD_FLASH := Color(0.6, 1.0, 0.7, 1.0)
const BAD_FLASH := Color(1.0, 0.55, 0.55, 1.0)
const PUNCH_SCALE := 1.03
const FLASH_IN_TIME := 0.04
const FLASH_OUT_TIME := 0.15

var swing_time := 0.0
var hits := 0

var start := false
var playing := false
var won := false
var timer_end := false
var finished := false

var metronome_base_scale := Vector2.ONE
var feedback_tween: Tween


func _ready() -> void:
	swing.pivot_offset = Vector2(swing.size.x / 2.0, swing.size.y)
	metronome_base_scale = metronome.scale
	metronome.pivot_offset = metronome.size / 2.0
	swing.rotation_degrees = MAX_ANGLE


func _process(delta: float) -> void:
	if start:
		start = false
		playing = true
		instructions.hide()
		swing_time = 0.0
		await themed_timer.Timer(6.0 + Global.extra_time)
		# after this is completed...
		if not finished:
			timer_end = true

	if playing:
		swing_time += delta * (BASE_SPEED + hits * SPEED_PER_HIT)
		swing.rotation_degrees = cos(swing_time) * MAX_ANGLE

		if Input.is_action_just_pressed("q") or Input.is_action_just_pressed("e") \
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not _mouse_was_down:
			_try_hit()

	_mouse_was_down = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if won:
		won = false
		finished = true
		playing = false
		Global.won = true
		await get_tree().create_timer(.5).timeout
		Transition.change_scene_to_file("res://scenes/done_screen.tscn")

	if timer_end:
		timer_end = false
		finished = true
		playing = false
		Global.lives -= 1
		Global.minigames_done -= 1
		Global.won = false
		
		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn")
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


var _mouse_was_down := false


func _try_hit() -> void:
	if finished:
		return

	var off_center: float = abs(swing.rotation_degrees)

	if off_center <= HIT_WINDOW:
		hits += 1
		_feedback(GOOD_FLASH, true)
		sound.play()
		if hits >= HITS_TO_WIN:
			won = true
			playing = false
	else:
		_feedback(BAD_FLASH, false)
		wrongSound.play()
		await get_tree().create_timer(1).timeout
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		timer_end = false
	
		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn")
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _feedback(color: Color, punch: bool) -> void:
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()

	feedback_tween = create_tween().set_parallel(true)
	feedback_tween.tween_property(metronome, "self_modulate", color, FLASH_IN_TIME)
	if punch:
		feedback_tween.chain()
		feedback_tween.tween_property(metronome, "self_modulate", Color.WHITE, FLASH_OUT_TIME)


func _on_start_pressed() -> void:
	start = true
