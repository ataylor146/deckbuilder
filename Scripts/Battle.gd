extends Node2D

@export var starting_deck: Array[CardData] = []   # накидай .tres карт в инспекторе
@export var hand_size := 5

@onready var player = $Player
@onready var enemy = $Enemy
@onready var hand_ui: HBoxContainer = $Hand
@onready var mana_label: Label = $ManaLabel

var draw_pile: Array[CardData] = []
var hand: Array[CardData] = []
var discard: Array[CardData] = []
var mana := 0

func _ready() -> void:
	draw_pile = starting_deck.duplicate()
	draw_pile.shuffle()
	$EndTurnButton.pressed.connect(end_turn)
	start_turn()

func start_turn() -> void:
	player.block = 0
	mana = player.MANA_PER_ROUND
	draw(hand_size)
	update_ui()

func draw(n: int) -> void:
	for i in n:
		if draw_pile.is_empty():
			if discard.is_empty(): return
			draw_pile = discard.duplicate()
			discard.clear()
			draw_pile.shuffle()
		hand.append(draw_pile.pop_back())

func play_card(card: CardData) -> void:
	if card.manaCost > mana:
		print("Не хватает маны")
		return
	mana -= card.manaCost
	hand.erase(card)
	discard.append(card)

	match card.cardType:
		CardData.CardType.DAMAGE:
			enemy.take_damage(card.amount)
		CardData.CardType.DEFENSE:
			player.block += card.amount
		CardData.CardType.EFFECT:
			pass
	update_ui()

func end_turn() -> void:
	discard.append_array(hand)
	hand.clear()
	if enemy.hp > 0:
		enemy.do_damage()
	start_turn()

func update_ui() -> void:
	mana_label.text = "Mana: %d" % mana
	for c in hand_ui.get_children():
		c.queue_free()
	for card in hand:
		var b := Button.new()
		b.text = "%s (%d)\n%s" % [card.cardName, card.manaCost, card.getDescription()]
		b.disabled = card.manaCost > mana
		b.pressed.connect(play_card.bind(card))
		hand_ui.add_child(b)
