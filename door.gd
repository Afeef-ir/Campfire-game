extends StaticBody2D

@onready var label: Label = $Label
@onready var sliding_door: Sprite2D = $SlidingDoor
@onready var lock: AnimatedSprite2D = $LockSprite
@onready var lock_pos_left: Marker2D = $LockSpritePosLeft
@onready var door_collison_pos: Marker2D = $LockColPosLeft
@onready var lock_area_pos: Marker2D = $LockAreaPos
@onready var lock_area: Area2D = $LockArea
@onready var lock_col: CollisionShape2D = $LockCol
@onready var open_audio: AudioStreamPlayer2D = $UnlockAudio

@export var is_unlocked : bool = false
@export var is_left : bool = false
@export var required_key_tag: String = "red"
@export var consume_key: bool = true

func _ready():
	label.text = required_key_tag
	if is_left:
		lock.global_position = lock_pos_left.global_position
		lock.flip_h = true
		lock_col.global_position = door_collison_pos.global_position
		lock_area.global_position = lock_area_pos.global_position
	if is_unlocked:
		_open()
		
func attempt_open(player) -> void:
	if not player or not player.has_method("has_key"):
		return
		
	if player.has_key(required_key_tag):
		# open the door
		_open()
		if consume_key:
			player.use_key(required_key_tag)
	else:
		_deny_open()

func _open():
	if is_unlocked:
		return
		
	is_unlocked = true
	open_audio.play()
	print("Door opened with key:", required_key_tag)
	if has_node("AnimationPlayer"):
		pass
	#lock_area.monitoring = false
	call_deferred("disable_monitoring")
	lock_col.queue_free()
	lock_area.queue_free()
	sliding_door.hide()
	sliding_door.queue_free()
	label.hide()
	label.queue_free()
	
func _deny_open():
	print("Door locked! needs key:", required_key_tag)

func _on_lock_area_body_entered(body) -> void:
	if body.is_in_group("Player"):
		attempt_open(body)
	
func disable_monitoring():
	lock_area.monitoring = false
