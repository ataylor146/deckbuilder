extends Button

var grabPos : Vector2
var formerPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button_pressed:
		position = formerPos + get_global_mouse_position() - grabPos

func _on_button_down() -> void:
	grabPos = get_global_mouse_position()
	formerPos = global_position

func _on_button_up() -> void:
	pass
