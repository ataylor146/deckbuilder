extends Node2D

const handWidth := 300.0
const typicalHandSpread := 50.0

var n_card:PackedScene =  load("res://Scenes/card.tscn")

var cardsInHand: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
	newCard.doDamage.connect(_damage_enemy)
	arrangeHand()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		drawCard(load("res://cards/heavy_shot.tres"))
		

func _on_card_card_placed(card:Node) -> void:
	if card.position.y < 200:
		card.play()
		cardsInHand.erase(card)

func _damage_enemy(amount:int) -> void:
	
	$Enemy.take_damage(amount)
