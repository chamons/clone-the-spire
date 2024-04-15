class_name EnemyHandler
extends Node2D

func update_enemy_actions() -> void:
	for enemy in get_children():
		enemy.current_action = null
		enemy.update_action()

func start_turn() -> void:
	for enemy in get_children():
		await enemy.do_turn()
