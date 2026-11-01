extends Node2D

@onready var themed_timer: Node2D = $Timer
@onready var barrier: StaticBody2D = $Barrier
@onready var barrierTwo: StaticBody2D = $Barrier2
@onready var instructions: TextureRect = $InstructionBg
@onready var platform6: Node2D = $Platform6 # the platform we're going to move
@onready var gif: AnimatedSprite2D = $InstructionBg/GifBackground/InstructionsGif
@onready var gifBackground: TextureRect = $InstructionBg/GifBackground
@onready var instructionText: RichTextLabel = $InstructionBg/Instructions

var start = false
var gifOpened = false

# how the platform moves (tweak these to change the difficulty)
var platform_distance = 150.0 # how many pixels it moves each way
var platform_time = 2.0 # seconds to go one direction

var note_collected = 0 # just keeping track of garlic collected
var timer_end = false # boolean (true or false) stating whether the timer ended

func _ready() -> void:
	Global.firstRound = false
	#Below you can see that I have a function that I named. I grab a 
	#function from it that was created in it's script and use `await` to 
	# tell the script to wait for a signal, or for when a function finshes


func move_platform() -> void:
	var start_x = platform6.position.x # remember where the platform begins
	var tween = create_tween().set_loops() # set_loops() with no number = repeat forever
	tween.set_trans(Tween.TRANS_SINE) # smooth speed up / slow down at the ends
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(platform6, "position:x", start_x + platform_distance, platform_time) # go right
	tween.tween_property(platform6, "position:x", start_x - platform_distance, platform_time) # go left


func _process(delta: float) -> void: # running every frame brochacho
	if start == true:	
		instructions.hide()
		barrier.free()
		barrierTwo.free()
		start = false
		move_platform() # platform 6 starts moving when the game starts
		await themed_timer.Timer(13 + Global.extra_time) #accessing a function from this node
		#after this is compeleted...
		timer_end = true # now we're saying "oh ye you ran out of time"
	if note_collected == 3: # the double equals is just an argument asking if it's the same, with "=" it'll give an error
			Global.won = true
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # go back to the intermission scene
	
	if timer_end: # if the timer does end...
		Global.minigames_done -=1 #go back a minigame
		Global.lives -= 1 # lose ur lives
		Global.won = false
		timer_end = false
		if Global.lives == 0:
			Transition.change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			Transition.change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission
		

func _on_guitar_pick_3_note_collected() -> void:
	note_collected = note_collected + 1
	pass # Replace with function body.


func _on_guitar_pick_2_note_collected() -> void:
	note_collected = note_collected + 1
	pass # Replace with function body.


func _on_guitar_pick_note_collected() -> void:
	note_collected = note_collected + 1
	pass # Replace with function body.
	


func _on_start_pressed() -> void:
	start = true


func _on_gif_button_pressed() -> void:
	if gifOpened == false:
		gif.show()
		gifBackground.show()
		gifOpened = true
		instructionText.hide()
		gif.play("default")
	else:
		gifBackground.hide()
		gif.hide()
		gifOpened = false
		instructionText.show()
