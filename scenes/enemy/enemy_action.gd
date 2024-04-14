class_name EnemyAction
extends Node

enum TYPE { CONDITIONAL, CHANCE_BASE }

@export var type: TYPE
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node2D

func is_performable() -> bool:
	return false

func perform_action() -> void:
	pass
