extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jumps_left = 2

func _physics_process(delta: float) -> void:
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
		jumps_left= 2
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if Input.is_action_pressed("sprint"):
		velocity *= 2
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
