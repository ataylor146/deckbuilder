extends Node2D

signal doDamage(amount:int)
signal defeated

var data: EnemyData
var MAX_HP = 5
var hp = MAX_HP
var damage = 1
@onready var progress_bar: ProgressBar = $HP
@onready var hp_text: Label = $HP/Label
@onready var nametag: Label = $Name

var cannons: Array[Cannon]

func _ready():
	cannons.append_array([$Cannon, $Cannon2, $Cannon3])
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
	nametag.text = data.name
	update_ui()

func take_damage(dmg: int) -> void:
	hp -= dmg
	Audio.sfx(Audio.ENEMYHURT)
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
