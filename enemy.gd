extends Node2D

signal doDamage(amount:int)
signal defeated

var MAX_HP = 5
var hp = MAX_HP
var damage = 1
@onready var progress_bar: ProgressBar = $VBoxContainer/HP
@onready var hp_text: Label = $VBoxContainer/HP/Label

func _ready():
	progress_bar.max_value = MAX_HP
	update_hp_ui()
	print(progress_bar.value)
	print(progress_bar.max_value)

func take_damage(dmg: int) -> void:
	hp -= dmg
	update_hp_ui()
	if hp <= 0:
		emit_signal("defeated")

func take_turn() -> void:
	fire_canon()

func fire_canon() -> void:
	emit_signal("doDamage", randi_range(2, 4))

func update_hp_ui() -> void:
	hp_text.text = str(hp)
	progress_bar.value = hp
