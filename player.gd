extends CharacterBody2D

@onready var progress_bar: ProgressBar = $CanvasLayer/Control/ProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var gun: Node2D = $Gun
signal shoot_stop
const SPEED = 500.0
const JUMP_VELOCITY = -850.0
const KNOCKBACK_TIME = 0.25
var can_move : bool
var jumps_left = 2
var bullet = preload("res://bullet.tscn")
var health = 100
var knockback_force = Vector2.ZERO
var shooting : bool
@onready var bullet_pos_1: Marker2D = $bullet_pos_1
@onready var bullet_pos_2: Marker2D = $bullet_pos_2

func _ready() -> void:

	gun.connect("fire",Callable(self,"on_fire"))
	get_tree().paused = false
	animated_sprite_2d.play("Idle")
func _physics_process(delta: float) -> void:
	if animated_sprite_2d.flip_h:
		gun.global_position = bullet_pos_2.global_position
	else:
		gun.global_position = bullet_pos_1.global_position
	if animated_sprite_2d.animation == "Shoot" and animated_sprite_2d.frame == 5:
		shoot_stop.emit()
		
		
		
	progress_bar.value = health
	if not is_on_floor():
		velocity += get_gravity() * delta* 1.25

	
	if Input.is_action_just_pressed("Jump") and jumps_left > 0 and not shooting:
		jumps_left -= 1
		velocity.y = JUMP_VELOCITY

	if jumps_left>2:
		jumps_left = 2
	if is_on_floor():
		jumps_left = 1
		
	var direction := Input.get_axis("Left", "Right")

	if direction and not shooting:
		if is_on_floor():
			animated_sprite_2d.play("Run")
		if Input.is_action_pressed("sprint"):
			velocity.x = direction * SPEED * 1.5
			
			if velocity.x != 0 and is_on_floor():
				animated_sprite_2d.speed_scale = 1.5
		else:
			if velocity.x != 0 and is_on_floor():
				animated_sprite_2d.speed_scale = 0.8
			velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = (velocity.x<0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor() and velocity.x == 0 and not shooting:
		animated_sprite_2d.play("Idle")
	elif not is_on_floor() and not shooting:
		if jumps_left == 0:
			if velocity.y < 0:
				animated_sprite_2d.play("jump")
			else:
				animated_sprite_2d.play("fall")
		else:
			if velocity.y <0:
				animated_sprite_2d.play("jump")
			elif velocity.y > 0:
				animated_sprite_2d.play("fall")
	
	if health <1:
		get_tree().paused = true
		animated_sprite_2d.play("Death")
		await animated_sprite_2d.animation_finished
		get_tree().reload_current_scene()
		
	move_and_slide()
	
func apply_knockback(from_position: Vector2, strength: float = 6000, upward: float = -900) -> void:
	var dir = (global_position - from_position).normalized()
	print(dir)
	knockback_force = Vector2(dir.x * strength, upward)
	set_deferred("velocity", knockback_force)
	print("Knockback from:", from_position, "to:", global_position)

func on_fire():
	if is_on_floor():
		shooting = true
		animated_sprite_2d.play("Shoot")
		await  animated_sprite_2d.animation_finished
		shooting = false
	

	
