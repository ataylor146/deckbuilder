extends Node2D

var MAX_HP = 100
var manpowerPerRound = 3
var manpower = 3
var CANNONS = 3
var hp = MAX_HP
var block = 0

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
	if (hp <= 0):
		get_tree().change_scene_to_file("res://Scenes/lose_scene.tscn")
	if CANNONS != check_cannons():
		CANNONS = check_cannons()
		print("--------------CANNON DESTROYED! NOW YOU HAVE " + str(CANNONS) + " CANNONS -------------------")

func heal(value: int) -> void:
	hp = min(hp + value, MAX_HP)
	update_ui()

func repair_cannons(value: int) -> void:
	CANNONS = min(CANNONS + value, 3)

func check_cannons() -> int:
	return ceili(float(hp) / MAX_HP * 3)
	
func update_ui() -> void:
	hp_text.text = str(hp)
	progress_bar.value = hp
