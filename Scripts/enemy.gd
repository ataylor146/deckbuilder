extends Node2D

signal doDamage(amount:int)
signal defeated

var data: EnemyData
var MAX_HP = 5
var hp = MAX_HP
var damage = 1
@onready var progress_bar: ProgressBar = $VBoxContainer/HP
@onready var hp_text: Label = $VBoxContainer/HP/Label
@onready var nametag: Label = $VBoxContainer/Name

func _ready():
	progress_bar.max_value = MAX_HP
	update_ui()
	print(progress_bar.value)
	print(progress_bar.max_value)

func setup(enemy_data:EnemyData) -> void:
	data = enemy_data
	if is_node_ready():
		_apply_data()
		

func _apply_data():
	MAX_HP = data.health
	hp = data.health
	damage = data.damage
	nametag.text = data.name
	update_ui()

func take_damage(dmg: int) -> void:
	hp -= dmg
	update_ui()
	if hp <= 0:
		emit_signal("defeated")

func take_turn() -> void:
	fire_canon()

func fire_canon() -> void:
	emit_signal("doDamage", damage)

func update_ui() -> void:
	hp_text.text = str(hp)
	progress_bar.value = hp
