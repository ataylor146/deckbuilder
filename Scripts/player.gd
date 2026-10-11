extends Node2D

signal cannonsChanged

var MAX_HP = 100
var manpowerPerRound = 3
var manpower = 3
const START_CANNONS := 4
var CANNONS := START_CANNONS
var hp = MAX_HP
var block = 0

@export var impacts: Array[Texture2D] = []
@export var cannons_positions: Array[Marker2D] = []
@export var lossFrameTime := 0.1

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
	update_cannons()

func take_damage(dmg: int) -> void:
	var absorbed = min(block, dmg)
	block -= absorbed
	dmg -= absorbed

	hp -= dmg
	update_ui()
	if hp <= 0:
		get_tree().change_scene_to_file("res://Scenes/lose_scene.tscn")
		return
	update_cannons()

func heal(value: int) -> void:
	hp = min(hp + value, MAX_HP)
	update_ui()
	update_cannons()

func add_block(value: int) -> void:
	block += value
	update_block_ui()

func update_block_ui():
	if block == 0:
		defence.visible = false
		return
	if defence.visible == false:
		defence.visible = true
	defence_text.text = str(block)

func update_ui() -> void:
	hp_text.text = str(hp)
	progress_bar.value = hp

func _cannons_from_hp() -> int:
	return clampi(ceili(float(hp) / MAX_HP * START_CANNONS), 0, cannons_positions.size())

# Пересчитывает пушки от HP: сломанные зажигают анимацию, починенные гаснут.
func update_cannons() -> void:
	var before := CANNONS
	CANNONS = _cannons_from_hp()
	for i in cannons_positions.size():
		var loss: Sprite2D = cannons_positions[i].get_node("Loss")
		var broken := i >= CANNONS
		if broken:
			if not loss.visible:
				loss.visible = true
				_animate_loss(loss)
		else:
			loss.visible = false

	if CANNONS != before:
		cannonsChanged.emit()

# Крутится, пока спрайт виден. Гасим visible — цикл сам завершится.
func _animate_loss(loss: Sprite2D) -> void:
	if impacts.is_empty():
		return
	var frame := 0
	while is_instance_valid(loss) and loss.visible:
		loss.texture = impacts[frame % impacts.size()]
		frame += 1
		await get_tree().create_timer(lossFrameTime).timeout
