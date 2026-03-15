extends Area2D

@export var tag:String = "red" 
@export var icon:Texture2D

@onready var key_collect:AudioStreamPlayer2D = $KeyCollect

var picked:bool = false

func _on_body_entered(body):
	if picked:
		return

	if body.has_method("pickup_key"):
		picked = true
		key_collect.play()
		body.pickup_key(tag, icon)
		hide()
		await get_tree().create_timer(1).timeout
		queue_free()  
