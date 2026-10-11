extends Resource
class_name CardData

enum CardType {
	ATTACK,
	DEFENSE,
	EFFECT,
}

enum EffectType {
	NONE,
	HEAL,
	DRAW,
	GAIN_MANA,
	BURN,
}

@export var cardName := "New Card"
@export_multiline var description := ""
@export var cardType := CardType.ATTACK
@export_range(0, 10) var manaCost := 1

@export_range(0, 99) var amount := 1

@export var effect := EffectType.NONE
@export var art: Texture2D
@export var sound: AudioStream

func getDescription(cannons := 1) -> String:
	if description.is_empty():
		return getDefaultDescription(cannons)
	return description.format({
		"amount": amount,
		"name": cardName,
		"cannons": cannons,
		"total": amount * cannons,
	})

func getDefaultDescription(cannons := 1) -> String:
	match cardType:
		CardType.ATTACK:
			return "Deal %d × %d" % [amount, cannons]
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
				EffectType.BURN:
					return "Set fire: %d damage each turn." % amount
				_:
					return ""
	return ""

func getTypeName() -> String:
	match cardType:
		CardType.ATTACK: return "ATTACK"
		CardType.DEFENSE: return "Defense"
		CardType.EFFECT: return "Effect"
	return "Unknown"
