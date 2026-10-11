extends Node2D

const handWidth := 300.0
const typicalHandSpread := 50.0
const arcHeight := 8.0
const cardTilt := 4.0

var n_card:PackedScene =  load("res://Scenes/card.tscn")
var n_cannon:PackedScene = load("res://Scenes/cannon.tscn")

var cardsInHand: Array[Card]

@export var starting_deck: Array[CardData] = []

var draw_pile: Array[CardData] = []
var discard: Array[CardData] = []

const HAND_SIZE := 5

enum States{
	PLAYER_TURN,
	OPPONENT_TURN,
	EXECUTION_STEP
}

var state := States.PLAYER_TURN

var enemy_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Enemy.doDamage.connect(_on_enemy_do_damage)
	$Enemy.setup(load("res://enemies/skipper.tres"))
	draw_pile = starting_deck.duplicate()
	draw_pile.shuffle()
	take_turn()

func _on_enemy_do_damage(amount: int) -> void:
	$Player.take_damage(amount)

func end_turn() -> void:
	if $Enemy.hp > 0:
		$Enemy.take_turn()
	take_turn()
	
func take_turn():
	$Player.block = 0
	$Player.update_block_ui()
	$Player.setManpower($Player.manpowerPerRound)
	refillHand()

func refillHand() -> void:
	while cardsInHand.size() < HAND_SIZE:
		if not drawFromPile():
			return

func drawFromPile() -> bool:
	if draw_pile.is_empty():
		if discard.is_empty():
			return false
		draw_pile = discard.duplicate()
		discard.clear()
		draw_pile.shuffle()
	drawCard(draw_pile.pop_back())
	return true
	
func handPositions(count: int) -> Array[Vector2]:
	var result: Array[Vector2]
	var spread: float = min(typicalHandSpread, handWidth / max(count, 1))

	for i in range(count):
		var t: float = i - (count - 1) / 2.0
		result.append($Hand.position + Vector2(t * spread, arcHeight * t * t))
	return result

func arrangeHand() -> void:
	var count := cardsInHand.size()
	var positions := handPositions(count)

	for i in range(count):
		var card := cardsInHand[i]
		var t: float = i - (count - 1) / 2.0
		card.homePosition = positions[i]
		card.homeRotation = deg_to_rad(t * cardTilt)
		card.z_index = i
		card.disabled = card.cost > $Player.manpower
		card.refreshDescription($Player.CANNONS)

func drawCard(data:CardData):
	var newCard:Card = n_card.instantiate()
	newCard.setup(data)
	cardsInHand.append(newCard)
	
	add_child(newCard)
	newCard.cardPlaced.connect(_on_card_card_placed)
	arrangeHand()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		end_turn()
		

func _on_card_card_placed(card: Card) -> void:
	if card.position.y >= 200:
		return
	if card.cost > $Player.manpower:
		return

	match card.cardType:
		CardData.CardType.ATTACK:
			_damage_enemy(card.data.amount * $Player.CANNONS)
		CardData.CardType.DEFENSE:
			$Player.add_block(card.data.amount)
		CardData.CardType.EFFECT:
			_apply_effect(card.data)

	$Player.setManpower($Player.manpower - card.cost)
	discard.append(card.data)
	cardsInHand.erase(card)
	card.queue_free()
	arrangeHand()


func _apply_effect(data: CardData) -> void:
	match data.effect:
		CardData.EffectType.HEAL:
			$Player.heal(data.amount)
		CardData.EffectType.DRAW:
			for i in data.amount:
				drawFromPile()
		CardData.EffectType.GAIN_MANA:
			$Player.setManpower($Player.manpower + data.amount)
		CardData.EffectType.REPAIR_CANNON:
			$Player.repair_cannons(data.amount)
		CardData.EffectType.NONE:
			pass
func _damage_enemy(amount:int) -> void:
	$Enemy.take_damage(amount)

func _on_enemy_defeated() -> void:
	if enemy_index == 4:
		Audio.sfx(Audio.CELEBRATION)
		# WIN GAME SCREEN
	enemy_index += 1
	print("enemy down!")
	$RoundWinScene.visible = true
	
