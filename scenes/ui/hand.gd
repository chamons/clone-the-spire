class_name Hand
extends HBoxContainer

var cards_played_this_turn := 0

func _ready() -> void:
	Events.card_played.connect(on_cards_played)
	for child in self.get_children():
		var card := child as Card
		card.parent = self
		card.reparent_requested.connect(on_card_reparent_requested)

func on_cards_played(_card: Card) -> void:
	self.cards_played_this_turn += 1

func on_card_reparent_requested(child: Card) -> void:
	child.reparent(self)
	var new_index := clampi(child.original_index - cards_played_this_turn, 0, self.get_child_count())
	move_child.call_deferred(child, new_index)
