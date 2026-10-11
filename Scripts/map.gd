extends Control

var index := 0
@onready var Enemies: Array[TextureButton] = [$Enemy1, $Enemy2, $Enemy3, $Enemy4, $Enemy5]
var cross_scene = preload("res://Scenes/cross.tscn")
var pin_scene = preload("res://Scenes/pin.tscn")
signal battle_selected(index: int)



func _ready() -> void:
	for i in range(Enemies.size()):
		Enemies[i].pressed.connect(_on_enemy_pressed.bind(i))

func next_cycle() -> void:
	create_cross()
	index += 1

func create_cross():
	var cross = cross_scene.instantiate()
	add_child(cross)
	cross.position = Enemies[index].position + Vector2(60, 60)
	var pin = pin_scene.instantiate()
	add_child(pin)
	pin.position = Enemies[index + 1].position + Vector2(60, 60)
	Enemies[index + 1].disabled = false
	Enemies[index].disabled = true
	
func _on_enemy_pressed(index: int) -> void:
	visible = false
	battle_selected.emit(index)
