extends Node2D

var speed = 2200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += Vector2(1,0).rotated(rotation)* speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass
	else:
		queue_free()
