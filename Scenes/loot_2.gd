extends Button

@onready var player = $"../../Player"

func _ready() -> void:
	print(player)
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("YOU GOT +1 CANNON")
	player.repair_cannons(1);
	$"../../Enemy".setup(load("res://enemies/skipper.tres"))
	$"../../RoundWinScene".visible = false
