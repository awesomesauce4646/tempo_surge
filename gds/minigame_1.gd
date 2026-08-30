extends Node2D
@onready var themed_timer: Node2D = $Timer
@onready var barrier: StaticBody2D = $Barrier
@onready var instructions: ColorRect = $InstructionBg
var start = false


var note_collected = 0 # just keeping track of garlic collected
var timer_end = false # boolean (true or false) stating whether the timer ended

func _ready() -> void:
		pass
		#Below you can see that I have a function that I named. I grab a 
		#function from it that was created in it's script and use `await` to 
		# tell the script to wait for a signal, or for when a function finshes


func _process(delta: float) -> void: # running every frame brochacho
	if start == true:	
		instructions.hide()
		barrier.free()
		start = false
		await themed_timer.Timer(9) #accessing a function from this node
		#after this is compeleted...
		timer_end = true # now we're saying "oh ye you ran out of time"
	if note_collected == 3: # the double equals is just an argument asking if it's the same, with "=" it'll give an error
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # go back to the intermission scene
	
	if timer_end: # if the timer does end...
		Global.minigames_done -=1 #go back a minigame
		Global.lives -= 1 # lose ur lives
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://scenes/lost_game.tscn") 
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn") # back to intermission
		

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
