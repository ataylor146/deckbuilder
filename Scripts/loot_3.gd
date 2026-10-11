extends Button

@onready var player = $"../../Player"

func _ready() -> void:
	print(player)
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("YOU GOT +1 HAND SIZE")
	$"../..".HAND_SIZE += 1;
	$"../../Enemy".setup(load("res://enemies/skipper.tres"))
	$"../../Map".visible = true
	$"../../Map".next_cycle()
	$"../../RoundWinScene".visible = false
