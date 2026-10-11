extends Resource
class_name EnemyData

@export var name: String
@export var health:int

# Из этого списка враг случайно выбирает, что сделает в следующий ход.
# Пусто — будет бить на damage, как раньше.
@export var actions: Array[EnemyAction] = []
