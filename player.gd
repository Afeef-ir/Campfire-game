extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0
var jumps_left = 2
var bullet = preload("res://bullet.tscn")
func _physics_process(delta: float) -> void:
	print(jumps_left)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and jumps_left > 0:
		jumps_left -= 1
		velocity.y = JUMP_VELOCITY
	if jumps_left>2:
		jumps_left = 2
	if is_on_floor():
		jumps_left = 1

		#hehe
	var direction := Input.get_axis("Left", "Right")

	if direction:
		if Input.is_action_pressed("sprint"):
			velocity = 1.1 * velocity
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
