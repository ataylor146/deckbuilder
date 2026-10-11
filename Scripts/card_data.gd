extends Resource
class_name CardData

enum CardType {
	MUNITION,
	DEFENSE,
	EFFECT,
}

enum EffectType {
	NONE,
	HEAL,
	DRAW,
	GAIN_MANA,
	REPAIR_CANNON,
}

@export var cardName := "New Card"
@export_multiline var description := ""
@export var cardType := CardType.MUNITION
@export_range(0, 10) var manaCost := 1

@export_range(0, 99) var amount := 1

@export var effect := EffectType.NONE
@export var munition := Cannon.Munition.NONE
@export var art: Texture2D
@export var sound: AudioStream

func getDescription() -> String:
	if description.is_empty():
		return getDefaultDescription()
	return description.format({"amount": amount, "name": cardName})

func getDefaultDescription() -> String:
	match cardType:
		CardType.MUNITION:
			return "Deal %d damage." % amount
		CardType.DEFENSE:
			return "Gain %d block." % amount
		CardType.EFFECT:
			match effect:
				EffectType.HEAL:
					return "Heal %d HP." % amount
				EffectType.DRAW:
					return "Draw %d card(s)." % amount
				EffectType.GAIN_MANA:
					return "Gain %d mana." % amount
				EffectType.REPAIR_CANNON:
					return "Repair %d cannon(s)." % amount
				_:
					return ""
	return ""

func getTypeName() -> String:
	match cardType:
		CardType.MUNITION: return "Munition"
		CardType.DEFENSE: return "Defense"
		CardType.EFFECT: return "Effect"
	return "Unknown"
