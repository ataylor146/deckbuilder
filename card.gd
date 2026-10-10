extends Button

signal cardPlaced(Node)

const MOVE_RATE := 1 # ms to clear half dist (lower is faster)

var grabPos : Vector2
var formerPos : Vector2

@export var homePosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button_pressed:
		position = formerPos + get_global_mouse_position() - grabPos
	else:
		position = homePosition

func _on_button_down() -> void:
	grabPos = get_global_mouse_position()
	formerPos = global_position

func _on_button_up():
	emit_signal("cardPlaced", self)

func play():
	print("Played")
	queue_free()
	
func setHomePos(p: Vector2):
	homePosition = p
