extends Node2D

var MAX_HP = 5
var hp = MAX_HP
var damage = 1
@onready var progress_bar: ProgressBar = $EnemyHP
@onready var hp_text: Label = $EnemyHP/Label
@onready var button: Button = $"../Button"

func _ready():
	progress_bar.max_value = MAX_HP
	button.pressed.connect(take_damage.bind(1))
	update_hp_ui()
	print(progress_bar.value)
	print(progress_bar.max_value)

func take_damage(dmg: int):
	hp -= dmg
	update_hp_ui()
	print(hp)
	if hp <= 0:
		print("Enemy killed")

func do_damage():
	$"../Player".take_damage(damage)
	print($"../Player".hp)

func update_hp_ui():
	hp_text.text = str(hp)
	progress_bar.value = hp
