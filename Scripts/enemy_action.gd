extends Resource
class_name EnemyAction

# Одно действие врага на ход. Поля складываются, поэтому
# "+5 блока и 5 урона" — это одно действие с damage = 5 и block = 5.
@export var actionName := ""
@export_range(0, 99) var damage := 0
@export_range(0, 99) var block := 0
@export_range(0, 99) var heal := 0

func describe() -> String:
	var parts: Array[String] = []
	if damage > 0:
		parts.append("ATK %d" % damage)
	if block > 0:
		parts.append("BLOCK %d" % block)
	if heal > 0:
		parts.append("HEAL %d" % heal)
	return " + ".join(parts)
