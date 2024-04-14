class_name Hand
extends HBoxContainer

@export var character_stats: CharacterStats

@onready var card_ui = preload("res://scenes/card/card.tscn")

func add_card(card: CardResource) -> void:
	var new_card := self.card_ui.instantiate()
	new_card.reparent_requested.connect(on_card_reparent_requested)
	new_card.card = card
	new_card.parent = self
	new_card.character_stats = self.character_stats
	add_child(new_card)

func discard_card(card: Card) -> void:
	card.queue_free()

func disable_hand() -> void:
	for card in get_children():
		card.disabled = true

func on_card_reparent_requested(child: Card) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, self.get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
