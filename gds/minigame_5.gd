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
@onready var instructions: Panel = $InstructionBg
@onready var harpStrung: AudioStreamPlayer2D = $HarpStrung
@onready var wrongString: AudioStreamPlayer2D = $WrongHarp


const HOVER_MULT := 1.20
const HOVER_TIME := 0.12
const SELECT_COLOR := Color(0.373, 1.0, 0.537, 1.0)
const WRONG_START := 0.17 # skips the silence at the start of harp-boing-1.mp3
const WIN_DELAY := 0.5 # lets the last string sound ring out before the scene changes

var timer_end = false
var start = false
var playing = false
var won = false
var finished = false

var selected: TextureButton = null # the point waiting for its partner
var partners := {} # point -> the point it should connect to
var strings := {} # point -> the string that appears when its pair connects
var done := {} # points that are already connected
var strung_count := 0

var hover_data := {} # btn -> base_scale, center, zoom, tween

func _ready() -> void:
	partners = {
		pointOne: pointTwo, pointTwo: pointOne,
		pointThree: pointFour, pointFour: pointThree,
		pointFive: pointSix, pointSix: pointFive,
	}
	strings = {
		pointOne: stringOne, pointTwo: stringOne,
		pointThree: stringTwo, pointFour: stringTwo,
		pointFive: stringThree, pointSix: stringThree,
	}
	for btn in [pointOne, pointTwo, pointThree, pointFour, pointFive, pointSix]:
		btn.mouse_entered.connect(_on_point_hover.bind(btn, true))
		btn.mouse_exited.connect(_on_point_hover.bind(btn, false))


func _process(delta: float) -> void:
	if start:
		start = false
		playing = true
		instructions.hide()
		await themed_timer.Timer(5.0 + Global.extra_time)
		#after this is completed...
		timer_end = true

	if won and not finished:
		finished = true
		Global.won = true
		await get_tree().create_timer(WIN_DELAY).timeout
		Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission

	if timer_end and not won:
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		timer_end = false

		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn")
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


# ---------- hover ----------

func _on_point_hover(btn: TextureButton, hovering: bool) -> void:
	# Captured on first hover so size/scale are final by then
	if not hover_data.has(btn):
		hover_data[btn] = {
			"base_scale": btn.scale,
			"center": btn.position + (btn.size / 2 * btn.scale).rotated(btn.rotation),
			"zoom": 1.0,
			"tween": null,
		}
	var d = hover_data[btn]
	if d.tween and d.tween.is_valid():
		d.tween.kill()
	var t := create_tween()
	t.tween_method(_set_point_zoom.bind(btn), d.zoom, HOVER_MULT if hovering else 1.0, HOVER_TIME)
	d.tween = t


func _set_point_zoom(z: float, btn: TextureButton) -> void:
	var d = hover_data[btn]
	d.zoom = z
	var s: Vector2 = d.base_scale * z
	btn.scale = s
	btn.position = d.center - (btn.size / 2 * s).rotated(btn.rotation)


# ---------- game logic ----------

func _point_pressed(btn: TextureButton) -> void:
	if not playing or won:
		return # ignore clicks while the instructions are up or after winning
	if done.has(btn):
		return # already part of a finished string

	# first click: pick a point
	if selected == null:
		selected = btn
		btn.modulate = SELECT_COLOR
		return

	# clicked the same point again: deselect
	if selected == btn:
		btn.modulate = Color.WHITE
		selected = null
		return

	# second click: is it the matching point?
	if partners[selected] == btn:
		strings[btn].show()
		harpStrung.play()
		done[selected] = true
		done[btn] = true
		btn.modulate = SELECT_COLOR # both stay green once connected
		selected = null
		strung_count += 1
		if strung_count >= 3:
			won = true
	else:
		wrongString.play(WRONG_START)
		selected.modulate = Color.WHITE
		selected = null


func _on_point_one_pressed() -> void:
	_point_pressed(pointOne)

func _on_point_two_pressed() -> void:
	_point_pressed(pointTwo)

func _on_point_three_pressed() -> void:
	_point_pressed(pointThree)

func _on_point_four_pressed() -> void:
	_point_pressed(pointFour)

func _on_point_five_pressed() -> void:
	_point_pressed(pointFive)

func _on_point_six_pressed() -> void:
	_point_pressed(pointSix)


func _on_start_pressed() -> void:
	start = true
