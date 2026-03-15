extends CharacterBody2D

# Constants
const SPEED = 600.0
const JUMP_VELOCITY = -900
const SPRINT_MULTIPLIER = 1.5

# Nodes
@onready var progress_bar: ProgressBar = $CanvasLayer/Control/ProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: Node2D = $Gun
@onready var bullet_pos_1: Marker2D = $bullet_pos_1
@onready var bullet_pos_2: Marker2D = $bullet_pos_2

# Audio
@onready var jump_sfx: AudioStreamPlayer2D = $Jump_sfx
@onready var walk: AudioStreamPlayer2D = $walk
@onready var death: AudioStreamPlayer2D = $Death
@onready var hurt: AudioStreamPlayer2D = $Hurt

# State
var health := 100
var jumps_left := 2
var shooting := false
var can_move := false
var knockback_force := Vector2.ZERO
var spawn_pos := Vector2.ZERO

# Preloads
var bullet = preload("res://bullet.tscn")

signal shoot_stop


func _ready() -> void:
	spawn_pos = global_position
	gun.connect("fire", Callable(self, "on_fire"))
	get_tree().paused = false
	animated_sprite_2d.play("Idle")


func _physics_process(delta: float) -> void:
	_sync_gun_position()
	_check_shoot_stop()
	progress_bar.value = health
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement()
	_update_animation()
	if health < 1:
		await _die()
	move_and_slide()


func _sync_gun_position() -> void:
	if animated_sprite_2d.flip_h:
		gun.global_position = bullet_pos_2.global_position
	else:
		gun.global_position = bullet_pos_1.global_position


func _check_shoot_stop() -> void:
	if animated_sprite_2d.animation == "Shoot" and animated_sprite_2d.frame == 5:
		shoot_stop.emit()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.25


func _handle_jump() -> void:
	if is_on_floor():
		jumps_left = 2
	jumps_left = min(jumps_left, 2)
	if Input.is_action_just_pressed("Jump") and jumps_left > 0 and not shooting:
		jump_sfx.play()
		jumps_left -= 1
		velocity.y = JUMP_VELOCITY


func _handle_movement() -> void:
	var direction := Input.get_axis("Left", "Right")
	if direction and not shooting:
		var is_sprinting := Input.is_action_pressed("sprint")
		var speed := SPEED * (SPRINT_MULTIPLIER if is_sprinting else 1.0)
		velocity.x = direction * speed
		animated_sprite_2d.flip_h = velocity.x < 0
		if is_on_floor():
			animated_sprite_2d.speed_scale = SPRINT_MULTIPLIER if is_sprinting else 0.8
			walk.pitch_scale = SPRINT_MULTIPLIER if is_sprinting else 1.0
			if not walk.playing:
				walk.play()
		else:
			walk.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if walk.playing:
			walk.stream_paused = true


func _update_animation() -> void:
	if shooting:
		return
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Run")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")


func _die() -> void:
	get_tree().paused = true
	animated_sprite_2d.play("Death")
	death.play()
	await animated_sprite_2d.animation_finished
	respawn()


func apply_knockback(from_position: Vector2, strength: float = 6000, upward: float = -900) -> void:
	hurt.play()
	var dir := (global_position - from_position).normalized()
	knockback_force = Vector2(dir.x * strength, upward)
	set_deferred("velocity", knockback_force)


func on_fire() -> void:
	if is_on_floor():
		shooting = true
		animated_sprite_2d.play("Shoot")
		await animated_sprite_2d.animation_finished
		shooting = false


func respawn() -> void:
	health = 100
	global_position = spawn_pos
	animated_sprite_2d.play("Idle")
	get_tree().paused = false
