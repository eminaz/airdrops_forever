extends Node

@export var pump_amount:float = 15.0

var coin_weight = 4

var game_manager:GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_first_node_in_group('GameManager')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_owner().global_transform.origin.y -= delta * coin_weight

func _on_body_entered(body):
	if body is Car:
		game_manager.pump_bonk(pump_amount)
		print('collision') 
		$AudioStreamPlayer.play()  # Play the coin collect sound
		await get_tree().create_timer(1).timeout
		get_owner().queue_free()


#func _on_audio_stream_player_finished():
	#get_owner().queue_free()
