extends Node2D

const handWidth := 300.0
const typicalHandSpread := 50.0

var n_card:PackedScene =  load("res://Scenes/card.tscn")
var n_cannon:PackedScene = load("res://Scenes/cannon.tscn")

var cardsInHand: Array[Card]

enum States{
	PLAYER_TURN,
	OPPONENT_TURN,
	EXECUTION_STEP
}

var state := States.PLAYER_TURN

var enemy_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Enemy.setup(load("res://enemies/skipper.tres"))


func handPositions(count: int) -> Array[Vector2]:
	var result: Array[Vector2]
	var spread: float
	if count * typicalHandSpread < handWidth:
		spread = typicalHandSpread
	else:
		spread = handWidth / count
	
	for i in range(count):
		result.append($Hand.position + Vector2(i * spread, 0.0))
	return result

func arrangeHand() -> void:
	var positions = handPositions(cardsInHand.size())
	for i in range(cardsInHand.size()):
		cardsInHand[i].homePosition = positions[i]
		cardsInHand[i].disabled = cardsInHand[i].cost > $Player.manpower

func drawCard(data:CardData):
	var newCard:Card = n_card.instantiate()
	newCard.setup(data)
	cardsInHand.append(newCard)
	
	add_child(newCard)
	newCard.cardPlaced.connect(_on_card_card_placed)
	arrangeHand()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		drawCard(load("res://cards/heavy_shot.tres"))
		

func _on_card_card_placed(card:Card) -> void:
	if card.cardType == CardData.CardType.MUNITION and card.munition != Cannon.Munition.NONE:
		if card.position.y < 200:
			$Player.setManpower($Player.manpower - card.cost)
			card.queue_free()
			cardsInHand.erase(card)
			arrangeHand()
			_damage_enemy(card.data.amount)
			#IF WE SHOT -> Audio.sfx(Audio.LOADGUN)


func _damage_enemy(amount:int) -> void:
	$Enemy.take_damage(amount)

func _on_enemy_defeated() -> void:
	if enemy_index == 4:
		Audio.sfx(Audio.CELEBRATION)
		# WIN GAME SCREEN
	enemy_index += 1
	print("enemy down!")
	$RoundWinScene.visible = true
	
