class_name CharacterStats
extends Stats

@export var starting_deck: CardPile
@export var cards_per_turn: int
@export var max_mana: int

var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func reset_mana() -> void:
	self.mana = self.max_mana
	stats_changed.emit()
	
func can_play_card(card: CardResource) -> bool:
	return self.mana >= card.cost

func create_instance() -> Resource:
	var instance = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance

func take_damage(damage: int):
	var inital_health := health
	super.take_damage(damage)
	if inital_health > health:
		Events.player_hit.emit()
