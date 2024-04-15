class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25

@export var hand: Hand

var character_stats: CharacterStats

func _ready() -> void:
	Events.card_played.connect(on_card_played)

func start_battle(stats: CharacterStats):
	self.character_stats = stats
	self.character_stats.draw_pile = character_stats.deck.duplicate(true)
	self.character_stats.draw_pile.shuffle()
	self.character_stats.discard = CardPile.new()

func start_turn() -> void:
	self.character_stats.block = 0
	self.character_stats.reset_mana()
	await draw_cards(self.character_stats.cards_per_turn)

func draw_cards(amount: int) -> void:
	for card in range(amount):
		draw_card()
		await get_tree().create_timer(HAND_DRAW_INTERVAL).timeout

func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character_stats.draw_pile.draw())

func end_turn() -> void:
	self.hand.disable_hand()
	await self.discard_cards()

func discard_cards() -> void:
	for card in hand.get_children():
		self.character_stats.discard.add_card(card.card)
		self.hand.discard_card(card)
		await get_tree().create_timer(HAND_DISCARD_INTERVAL).timeout

func reshuffle_deck_from_discard() -> void:
	if not self.character_stats.draw_pile.empty():
		return

	while not self.character_stats.discard.empty():
		self.character_stats.draw_pile.add_card(self.character_stats.discard.draw())

	self.character_stats.draw_pile.shuffle()
	
func on_card_played(card: CardResource) -> void:
	self.character_stats.discard.add_card(card)
	
