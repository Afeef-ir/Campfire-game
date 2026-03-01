extends Node2D

@onready var rotational_offset: Marker2D = $Rotational_offset

@onready var shoot_pos: Marker2D = $Shoot_pos


var player
var bullet = preload("res://bullet.tscn")
var anim_player
func _ready() -> void:
	player = get_parent()
	anim_player = player.get_node("AnimatedSprite2D")
	#anim_player.frame_changed.connect(_on_animated_sprite_2d_frame_changed)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#var mouse_pos = get_global_mouse_position()
	#var mouse_vector = mouse_pos - rotational_offset.global_position
	#rotation = mouse_vector.angle()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		#if anim_player.frame == 3:
			#shoot()
		
		
func shoot():
	
	var new_bullet = bullet.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = shoot_pos.global_position
	if player.flip_h:
		new_bullet.rotation_degrees = 180
	
