extends Node

signal card_aim_started(card: Card)
signal card_aim_ended(card: Card)
signal card_played(card: CardResource)
signal card_drag_started(card: Card)
signal card_drag_ended(card: Card)
signal card_tooltip_requested(card: Card)
signal card_tooltip_hide_requested()

signal player_hand_draw()
signal player_hand_discarded()
signal player_turn_ended()
signal player_died()
signal player_hit()

signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended()
