class_name Hand
extends HBoxContainer

func _ready() -> void:
	for child in self.get_children():
		var card := child as Card
		card.reparent_requested.connect(_on_card_reparent_requested)

func _on_card_reparent_requested(child: Card) -> void:
	child.reparent(self)
