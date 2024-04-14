extends EnemyAction

@export var block := 15
@export var hp_threshold := 6

@onready var already_used := false

func is_performable() -> bool:
	if not self.enemy or not self.target:
		return false
	return enemy.stats.health <= self.hp_threshold and not self.already_used

func perform_action() -> void:
	if not self.enemy or not self.target:
		return
	
	self.already_used = true
	var effect := BlockEffect.new()
	effect.amount = self.block
	effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(func(): Events.enemy_action_completed.emit(enemy))
