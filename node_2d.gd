extends Node2D
@onready var bgm: AudioStreamPlayer = $BGM

var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgm.play()
	player = get_node("Player")
	player.spawn_pos = player.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bgm.playing == false:
		bgm.play()


func _on_killzone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
