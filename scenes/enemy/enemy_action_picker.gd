class_name EnemyActionPicker
extends Node

@export var enemy: Enemy: set = set_enemy
@export var target: Node2D: set = set_target

@onready var total_weight := 0.0

func _ready() -> void:
	self.target = get_tree().get_first_node_in_group("player")
	setup_chances()

func set_enemy(value: Enemy) -> void:
	enemy = value
	for action in get_children():
		action.enemy = enemy
	
func set_target(value: Node2D) -> void:
	target = value
	for action in get_children():
		action.target = target

func setup_chances() -> void:
	for action in get_all_chance_based_actions():
		self.total_weight += action.chance_weight
		action.accumulated_weight = total_weight

func get_action() -> EnemyAction:
	var action := self.get_first_conditional_action()
	if action:
		return action
	return self.get_chance_based_action()
	
func get_chance_based_action() -> EnemyAction:
	var roll := randf_range(0.0, self.total_weight)
	var actions = get_all_chance_based_actions()
	return actions.filter(func(action): return action.accumulated_weight > roll).front()

func get_first_conditional_action() -> EnemyAction:
	var performable_actions = get_all_conditional_actions().filter(func(action): return action.is_performable())
	return performable_actions.front()
	
func get_all_chance_based_actions() -> Array:
	return self.get_children().filter(func(action): return action.type == EnemyAction.TYPE.CHANCE_BASE)

func get_all_conditional_actions() -> Array:
	return self.get_children().filter(func(action): return  action.type == EnemyAction.TYPE.CONDITIONAL)
