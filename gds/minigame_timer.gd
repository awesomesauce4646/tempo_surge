extends Node2D
@onready var timer: RichTextLabel = $timer #literally just the richlabeltext

var time : float
var total_time : float = 1.0 # how long this minigame started with
var running = false

var panic_percent = 0.25 # panic mode starts when 25% of the time is left

var music = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.pivot_offset = Vector2(0, timer.size.y / 2)
	music = get_node_or_null("/root/GlobalMusic")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer.text = str(snapped(time, 0.10)) # this makes names easier

	var panic_time = total_time * panic_percent

	if running and time <= panic_time:
		var urgency = 1.0 - (time / panic_time) # 0 when panic starts, 1 at 0 sec

		# pulse every second
		var pulse = fmod(time, 1.0)
		var s = 1.0 + 0.12 * pulse * pulse
		timer.scale = Vector2(s, s)

		timer.modulate = Color.WHITE.lerp(Color(1, 0.3, 0.3), urgency)

		if music:
			music.pitch_scale = lerp(1.0, 1.08, urgency)
	else:
		timer.scale = Vector2(1, 1)
		timer.modulate = Color.WHITE

func Timer(start_time: float): # making a new function for timer countdown!
	# we want the timer to go down, and when it reaches 0 it transitions 
	# to the next scene!
	
	time = start_time
	total_time = start_time 
	running = true
	
	while time > 0.0: # run if timer hasnt reached 0
		await wait(0.10)
		time = time - 0.10
	
	#when timer reaches 0
	running = false
	if music:
		music.pitch_scale = 1.0
	return
	
func wait(seconds: float) -> void: # write this simple function out for wait!
	await get_tree().create_timer(seconds).timeout # makes u wait

func _exit_tree() -> void:
	if music:
		music.pitch_scale = 1.0
