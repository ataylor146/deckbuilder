extends Node2D

signal doDamage(amount:int)
signal defeated

var data: EnemyData
var MAX_HP = 5
var hp = MAX_HP
var damage = 1
var burn := 0
var block := 0
var nextAction: EnemyAction

@onready var progress_bar: ProgressBar = $HP
@onready var hp_text: Label = $HP/Label
@onready var intent_text: Label = get_node_or_null("Intent")

@export var impacts: Array[Texture2D] = []
@onready var sprite: Sprite2D = $Impact1

var cannons: Array[Cannon]

func _ready():
	progress_bar.max_value = MAX_HP
	update_ui()

func setup(enemy_data:EnemyData) -> void:
	data = enemy_data
	if is_node_ready():
		_apply_data()
		

func _apply_data():
	MAX_HP = data.health
	hp = data.health
	damage = data.damage
	burn = 0
	block = 0
	pick_action()
	update_ui()

# Случайно выбирает, что враг сделает в следующий ход, и показывает это игроку.
func pick_action() -> void:
	if data != null and not data.actions.is_empty():
		nextAction = data.actions.pick_random()
	else:
		nextAction = null
	update_intent()

func take_damage(dmg: int) -> void:
	var absorbed = min(block, dmg)
	block -= absorbed
	dmg -= absorbed

	hp -= dmg
	play_impact()
	Audio.sfx(Audio.ENEMYHURT)
	update_ui()
	if hp <= 0:
		emit_signal("defeated")
		
func play_impact() -> void:
	sprite.visible = true
	for tex in impacts:
		sprite.texture = tex
		await get_tree().create_timer(0.1).timeout
	sprite.visible = false

func heal(value: int) -> void:
	hp = min(hp + value, MAX_HP)
	update_ui()

func add_burn(amount: int) -> void:
	burn += amount
	update_ui()

func tick_burn() -> void:
	if burn <= 0:
		return
	take_damage(burn)

func take_turn() -> void:
	# Блок держится весь ход игрока и сбрасывается здесь, перед новым действием
	block = 0

	if nextAction == null:
		fire_canon()
	else:
		if nextAction.block > 0:
			block += nextAction.block
		if nextAction.heal > 0:
			heal(nextAction.heal)
		if nextAction.damage > 0:
			emit_signal("doDamage", nextAction.damage)

	update_ui()
	pick_action()

func fire_canon() -> void:
	emit_signal("doDamage", damage)

func update_intent() -> void:
	if intent_text == null:
		return
	intent_text.text = nextAction.describe() if nextAction != null else "ATK %d" % damage

func update_ui() -> void:
	hp_text.text = str(hp)
	if block > 0:
		hp_text.text += " [" + str(block) + "]"
	if burn > 0:
		hp_text.text += " (" + str(burn) + ")"
	progress_bar.value = hp
