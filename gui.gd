class_name GUI extends Node


@onready var time_indication:Label = $TimeIndication
@onready var coins_indication:Label = $CoinsIndication
@onready var bonk_indication = $BonkIndication
@onready var final_coins_indication:Label = $LoseScreen/FinalCoinsIndication
@onready var win_screen:Control = $WinScreen
@onready var lose_screen:Control = $LoseScreen

@onready var claim_button:Button = $LoseScreen/ClaimButton

var vault_wallet_path = "/Users/markxie/Documents/Q91Gy4MqTgeTJ5TJzGGU78qwj3swFDJmHxrwBJiJ6oo.json"

var game_manager:GameManager


func _init():
	add_to_group('GUI')
	
# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_first_node_in_group('GameManager')
	win_screen.visible = false
	lose_screen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_indication.text = "Time left: %s" % str(game_manager.get_current_time())

func handle_coin_collected(collected_coins_count):
	coins_indication.text = "%s Coin       " % str(game_manager.get_collected_coins_count())

func handle_bonk_collected(collected_bonk_count):
	bonk_indication.text = "%s Bonk" % str(game_manager.get_collected_bonk_count())

func handle_game_win(collected_coins_count:int) -> void:
	win_screen.visible = true
	
	
func handle_game_lose() -> void:
	lose_screen.visible = true
	var coins_count = game_manager.get_collected_coins_count()
	var bonk_count = game_manager.get_collected_bonk_count()
	final_coins_indication.text = "You collected %s coins" % str(coins_count) + " and %s bonks" % str(bonk_count)
	if coins_count >= 2:
		var wallet_address = SolanaService.wallet.get_pubkey().to_string();
		if wallet_address:
			claim_button.visible = true
	else:
		claim_button.visible = false

func handle_restart():
	win_screen.visible = false
	lose_screen.visible = false


func _on_claim_button_pressed():
	claim_button.disabled = true
	
	var coins_count = game_manager.get_collected_coins_count()
	var bonk_count = game_manager.get_collected_bonk_count()
		
	var receiver = SolanaService.wallet.get_pubkey().to_string()
	var prize_amount = coins_count/1000 + bonk_count/500
	var signer = Keypair.new_from_file(vault_wallet_path)
	
	var tx_id = await SolanaService.transfer_sol_to_address(receiver, prize_amount, signer)
	if tx_id == "":
		claim_button.disabled = false
	else:
		claim_button.text = "Claimed!"
	
