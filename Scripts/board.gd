extends Node2D

const handWidth := 300.0
const typicalHandSpread := 50.0

var n_card:PackedScene =  load("res://Scenes/card.tscn")
var n_cannon:PackedScene = load("res://Scenes/cannon.tscn")

var cardsInHand: Array[Card]

var step = true

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

func drawCard(data:CardData):
	var newCard:Card = n_card.instantiate()
	newCard.setup(data)
	cardsInHand.append(newCard)
	
	add_child(newCard)
	newCard.cardPlaced.connect(_on_card_card_placed)
	arrangeHand()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		drawCard(load("res://cards/heavy_shot.tres"))
		

func _on_card_card_placed(card:Card) -> void:
	if card.cardType == CardData.CardType.MUNITION and card.munition != Cannon.Munition.NONE:
		var closestCannon = find_nearest_cannon(card)
		if closestCannon != null and closestCannon.loadedMunition == Cannon.Munition.NONE:
			closestCannon.loadedMunition = card.munition
			closestCannon.updateMunition()
			card.queue_free()
			cardsInHand.erase(card)
			arrangeHand()

func find_nearest_cannon(card:Card) -> Cannon:
	var nearest: Cannon = $Player.cannons[0]
	for i in $Player.cannons:
		if i.position.distance_to(card.position) < nearest.position.distance_to(card.position):
			nearest = i
	if nearest.position.distance_to(card.position) < 200:
		return nearest
	else:
		return null


func _damage_enemy(amount:int) -> void:
	$Enemy.take_damage(amount)

func _on_enemy_defeated() -> void:
	print("enemy down!")
	$Enemy.setup(load("res://enemies/skipper.tres"))
