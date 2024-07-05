class_name GameManager extends Node

var coin_scene = preload("res://Coin.tscn")
var coin_timer = 1.5
var time_since_last_coin = 0.0

#var cat_scene = preload("res://cat.tscn")
var bonk_scene = preload("res://bonk.tscn")

static var current_time = 60
static var collected_coins_count = 0
static var collected_bonk_count = 0

#var dump_rate = 3
var game_active = true;

@export var gui:GUI

func _init():
	add_to_group('GameManager')
	print('GameManager init')
	
# Called when the node enters the scene tree for the first time.
func _ready():
	print('GameManager ready')
	if $AudioStreamPlayer:
		$AudioStreamPlayer.play()
	gui = get_tree().get_first_node_in_group('GUI')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !game_active:
		return
		
	time_since_last_coin += delta
	if time_since_last_coin >= coin_timer:
		spawn_coin()
		spawn_coin()
		spawn_coin()
		spawn_coin()
		spawn_bonk()
		spawn_bonk()
		#spawn_cat_coin()
		#spawn_cat_coin()
		#spawn_cat_coin()
		#spawn_cat_coin()
		
		time_since_last_coin = 0.0
	
	current_time -= delta
	
	if current_time < 0:
		current_time = 0
		game_active = false
		lose_game()
		
func pump(amount:float) -> void:
	current_time += amount
	collected_coins_count += 1
	gui.handle_coin_collected(collected_coins_count)

func pump_bonk(amount):
	current_time += amount
	collected_bonk_count += 1
	gui.handle_bonk_collected(collected_bonk_count)

func get_current_time() -> float:
	var rounded_time = snapped(current_time, 0.01)
	return rounded_time

func get_collected_coins_count():
	return collected_coins_count

func get_collected_bonk_count():
	return collected_bonk_count
	
func win_game() -> void:
	game_active = false
	gui.handle_game_win(collected_coins_count)
	print('WIN!!')

func lose_game() -> void:
	gui.handle_game_lose()
	if $AudioStreamPlayer:
		$AudioStreamPlayer.stop()
	set_process_input(false)

func spawn_coin():
	#print('spawn_coin')
	var coin = coin_scene.instantiate()
	#coin.position = Vector3(randf_range(-30, 50), 5, randf_range(-30, 50))  # Set random Y and Z position
	coin.position = Vector3(randf_range(-100, 100), randf_range(15, 30), randf_range(-100, 100))  # Set random Y and Z position
	get_parent().add_child(coin)


func spawn_bonk():
	var bonk = bonk_scene.instantiate()
	bonk.position = Vector3(randf_range(-100, 100), randf_range(15, 30), randf_range(-100, 100))  # Set random Y and Z position
	get_parent().add_child(bonk)	
	
#func spawn_cat_coin():
	#var cat = cat_scene.instantiate()
	#cat.position = Vector3(randf_range(-100, 100), randf_range(15, 30), randf_range(-100, 100))  # Set random Y and Z position
	#get_parent().add_child(cat)	


func _on_audio_stream_player_finished():
	print('_on_audio_stream_player_finished')
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play(0)


func _on_button_pressed():

	gui.handle_restart()
	queue_free()
	game_active = true
	current_time = 60
	collected_coins_count = 0
	get_tree().reload_current_scene()

