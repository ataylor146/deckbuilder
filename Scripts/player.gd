extends Node2D

var MAX_HP = 100
var manpowerPerRound = 3
var manpower = 3
var CANNONS := 4
var hp = MAX_HP
var block = 0

@onready var defence: Sprite2D = $Defence
@onready var defence_text: Label = $Defence/Label

@onready var progress_bar: ProgressBar = $HP
@onready var hp_text: Label = $HP/Label
var cannons: Array[Cannon]

func setManpower(n: int):
	manpower = n
	$Manpower.text = "Manpower: " + str(n)

func _ready() -> void:
	setManpower(manpowerPerRound)
	progress_bar.max_value = MAX_HP
	update_ui()
	
func take_damage(dmg: int) -> void:
	var absorbed = min(block, dmg)
	block -= absorbed
	dmg -= absorbed

	hp -= dmg
	update_ui()
	if hp <= 0:
		get_tree().change_scene_to_file("res://Scenes/lose_scene.tscn")
		return

func heal(value: int) -> void:
	hp = min(hp + value, MAX_HP)
	update_ui()

func add_block(value: int) -> void:
	block += value
	update_block_ui()

func update_block_ui():
	print(block)
	if block == 0:
		defence.visible = false
		return
	if defence.visible == false:
		defence.visible = true
	defence_text.text = str(block)

	
func update_ui() -> void:
	hp_text.text = str(hp)
	progress_bar.value = hp
