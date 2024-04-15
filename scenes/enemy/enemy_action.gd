class_name EnemyAction
extends Node

enum TYPE { CONDITIONAL, CHANCE_BASE }

@export var intent: Intent
@export var type: TYPE
@export_range(0.0, 10.0) var chance_weight := 0.0
@export var sound: AudioStream

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node2D

func is_performable() -> bool:
	return false

func perform_action() -> void:
	await get_tree().create_timer(0.1, false).timeout

var last_target_starting_position : Vector2

func move_in_front_of_player() -> void:
	last_target_starting_position = enemy.global_position
	var in_front := target.global_position + Vector2.RIGHT * 32
	var tween := self.create_tween().set_trans(Tween.TRANS_QUINT)
	tween.tween_property(enemy, "global_position", in_front, 0.4)
	tween.tween_interval(0.35)
	await tween.finished
	
func move_back_to_position() -> void:
	var tween := self.create_tween().set_trans(Tween.TRANS_QUINT)
	tween.tween_property(enemy, "global_position", last_target_starting_position, 0.4)
	tween.tween_interval(0.25)
	await tween.finished
