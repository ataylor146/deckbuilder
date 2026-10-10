extends Node2D

var MAX_HP = 100
var MANA_PER_ROUND = 3
var CANNONS = 3
var hp = MAX_HP

func _ready() -> void:
	pass
	
func test_damage():
	while hp > 0:
		await get_tree().create_timer(0.1).timeout
		take_damage(1)

func take_damage(dmg: int) -> void:
	hp -= dmg
	if (hp <= 0):
		print("LOSE")
	if CANNONS != check_cannons():
		CANNONS = check_cannons()
		print("--------------CANNON DESTROYED! NOW YOU HAVE " + str(CANNONS) + " CANNONS -------------------")
	
func check_cannons() -> int:
	return ceili(float(hp) / MAX_HP * 3)
	
