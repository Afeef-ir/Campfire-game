extends CharacterBody2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var start_pos : Vector2 
@export var end_pos : Vector2

var health = 100
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var go_forward : bool
func _ready() -> void:
	go_forward = true
	
func _physics_process(delta: float) -> void:
	progress_bar.value = health
	var end_diff = end_pos.x- global_position.x
	var start_diff = start_pos.x - global_position.x
	animated_sprite_2d.flip_h = (velocity.x > 0)
	if go_forward == true:
		velocity.x = SPEED
	if abs(end_diff) <10:
		go_forward = false
	if abs(start_diff)<10:
		go_forward = true
	if go_forward == false:
		velocity.x = -SPEED
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	if health<=0:
		queue_free()
	move_and_slide()


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		body.health -= 40
		body.apply_knockback(global_position)
		var anim = body.get_node("AnimationPlayer")
		anim.play("hurt")


func _on_hurt_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		animation_player.play("hit")
		health -=40
