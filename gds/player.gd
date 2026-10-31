extends CharacterBody2D

@onready var jumpNoise: AudioStreamPlayer2D = $Jump
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const REST_FRAME = 0 

func _ready() -> void:
	anim.stop()
	anim.frame = REST_FRAME

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpNoise.play()

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if direction > 0:
		anim.play("default")
	elif direction < 0:
		anim.play_backwards("default")
	else:
		if anim.frame == 0:
			anim.stop()
