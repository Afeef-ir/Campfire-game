extends Node2D

@onready var sfx: AudioStreamPlayer2D = $SFX
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var used : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !used:
			sfx.play()
			body.spawn_pos = global_position
			animated_sprite_2d.modulate = "green"
			used = true
