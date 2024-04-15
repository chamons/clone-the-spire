extends Node

signal card_aim_started(card: Card)
signal card_aim_ended(card: Card)
signal card_played(card: CardResource)
signal card_drag_started(card: Card)
signal card_drag_ended(card: Card)
signal card_tooltip_requested(card: Card)
signal card_tooltip_hide_requested()

signal player_died()
signal player_hit()

signal battle_over_screen_requested(text: String, type: BattleOverPanel.TYPE)
