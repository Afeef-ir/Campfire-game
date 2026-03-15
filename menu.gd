extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var level ="res://node_2d.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(level)


func _on_quit_pressed() -> void:
	get_tree().quit()
