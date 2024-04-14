class_name EnemyHandler
extends Node2D

func _ready() -> void:
	Events.enemy_action_completed.connect(on_enemy_action_completed)
	
func on_enemy_action_completed(enemy: Enemy) -> void:
	var next_enemy : Enemy = F.child_at(self, enemy.get_index() + 1) as Enemy
	if next_enemy:
		next_enemy.do_turn()
	else:
		Events.enemy_turn_ended.emit()

func reset_enemy_action() -> void:
	for enemy in get_children():
		enemy.current_action = null
		enemy.update_action()

func start_turn() -> void:
	var first_enemy = F.child_at(self, 0) as Enemy
	if first_enemy:
		first_enemy.do_turn()
