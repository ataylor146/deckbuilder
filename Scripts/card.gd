class_name Card
extends Button

signal cardPlaced(Card)

var grabPos : Vector2
var formerPos : Vector2
var formerZ: int
var data : CardData
var munition: Cannon.Munition
var cardType: CardData.CardType
var cost: int

@export var homePosition : Vector2


func setup(card_data:CardData):
	data = card_data
	if is_node_ready():
		_apply_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_apply_data()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button_pressed:
		position = formerPos + get_global_mouse_position() - grabPos
	else:
		position = homePosition

func _on_button_down() -> void:
	grabPos = get_global_mouse_position()
	formerPos = global_position
	formerZ = z_index
	z_index = 100

func _on_button_up():
	emit_signal("cardPlaced", self)
	z_index = formerZ

func _apply_data() -> void:
	$VBoxContainer/HBoxContainer/Title.text = data.cardName
	$VBoxContainer/Art.texture = data.art
	
	if not data.description.is_empty():
		$VBoxContainer/Description.text = data.description 
	else:
		$VBoxContainer/Description.text = data.getDefaultDescription()
	cardType = data.cardType
	munition = data.munition
	cost = data.manaCost
	$VBoxContainer/HBoxContainer/Cost.text = str(cost)

func play():
	print("unimplemented effect")
	queue_free()
	
func setHomePos(p: Vector2):
	homePosition = p
