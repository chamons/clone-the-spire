class_name CardPile
extends Resource

signal card_pile_size_changed(amount)

@export var cards : Array[CardResource] = []

func empty() -> bool:
	return self.cards.is_empty()
	
func draw() -> CardResource:
	var card = self.cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card
	
func add_card(card: CardResource) -> void:
	self.cards.append(card)
	card_pile_size_changed.emit(cards.size())

func shuffle() -> void:
	self.cards.shuffle()
	
func clear() -> void:
	self.cards.clear()
	card_pile_size_changed.emit(cards.size())
	
func _to_string() -> String:
	var card_strings: PackedStringArray = []
	for i in range(cards.size()):
		card_strings.append("%s: %s" % [i + i, cards[i].id])
	return "\n".join(card_strings)
