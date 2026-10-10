extends Node2D
class_name Cannon

@export var loadedMunition := Munition.NONE
@export var lit := false
@export var opposing := false

@onready var munitionSprite = $MunitionSprite


enum Munition{
	NONE,
	CANNONBALL,
	NET,
	CHAFF,
	GLUEBALL
}

func updateMunition():
	match loadedMunition:
		Munition.CANNONBALL:
			munitionSprite.texture = load("res://Sprites/cannonball.png")
		Munition.NET:
			munitionSprite.texture = load("res://Sprites/net.png")
		Munition.CHAFF:
			munitionSprite.texture = load("res://Sprites/chaff.png")
		Munition.GLUEBALL:
			munitionSprite.texture = load("res://Sprites/gluball.png")
		_:
			munitionSprite.visible = false

func updateCannon():
	if opposing:
		$CannonSprite.texture = load("res://Sprites/opposingCannon.png")
	else:
		$CannonSprite.texture = load("res://Sprites/cannon.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateMunition()
	updateCannon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
