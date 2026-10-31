extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var info: RichTextLabel = $RichTextLabel
@onready var instructions: TextureRect = $InstructionBg
@onready var upArrow: TextureButton = $up
@onready var downArrow: TextureButton = $down
@onready var gif: AnimatedSprite2D = $InstructionBg/InstructionsGif
@onready var instructionText: RichTextLabel = $InstructionBg/Instructions
@onready var gifButton: TextureButton = $InstructionBg/GifButton

const SHINE_COLOR := Color(1.5, 1.5, 1.5, 1.0) # raise toward 2.0 for a stronger shine
const SHINE_TIME := 0.2

var gifOpened = false

var buttons_pressed := 0
var timer_end = false
var rng = RandomNumberGenerator.new()
var random_number = rng.randf_range(0, 2.0)
var start = false
var playing = false
var finished = false # set when the minigame ends so win and timer can't both fire
var shine_tweens := {}

func _ready() -> void:
	upArrow.pressed.connect(_shine.bind(upArrow))
	downArrow.pressed.connect(_shine.bind(downArrow))


func _process(delta: float) -> void:
	if start:
		instructions.hide()
		start = false
		playing = true
		info.show()
		await themed_timer.Timer(4.5 + Global.extra_time)
		#after this is completed...
		timer_end = true 
	
	if random_number > 1: 
		info.text = "SHARP! 
TUNE DOWN! 
(CLICK 20)"
	else:
		info.text = "FLAT!
TUNE UP! (CLICK 20)"
	if buttons_pressed == 10:
		var new_texture = preload("res://assets/eh.png")
		$Face.set_texture(new_texture)
	if buttons_pressed == 18:
		var new_texture = preload("res://assets/happy.png")
		$Face.set_texture(new_texture)

	
	if buttons_pressed == 20 and not finished:
		finished = true
		#Global.minigames_done += 1
		Global.won = true
		Transition.change_scene_to_file("res://scenes/level_scene.tscn")
	
	if timer_end and not finished:
		finished = true
		Global.lives -= 1
		Global.minigames_done -=1
		Global.won = false
		timer_end = false
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission


func _shine(btn: TextureButton) -> void:
	if not playing:
		return # no shine while the instructions are up
	var old = shine_tweens.get(btn)
	if old and old.is_valid():
		old.kill()
	btn.modulate = SHINE_COLOR
	var t := create_tween()
	t.tween_property(btn, "modulate", Color.WHITE, SHINE_TIME).set_ease(Tween.EASE_OUT)
	shine_tweens[btn] = t


func _on_start_pressed() -> void:
	start = true
	pass # Replace with function body.


func _on_gif_button_pressed() -> void:
	if gifOpened == false:
		gif.play("default")
		gif.show()
		gifOpened = true
		instructionText.hide()
	else:
		gif.hide()
		gifOpened = false
		instructionText.show()
