class_name CardResource

extends Resource

enum Type { ATTACK, SKILL, POWER }
enum Target { SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE }
enum EffectKind { DAMAGE, BLOCK }

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var effect: EffectKind
@export var strength: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip: String

func is_single_target() -> bool:
	return self.target == Target.SINGLE_ENEMY

func get_targets(targets: Array[Node]) -> Array[Node]:
	# Change to assert
	if not targets:
		return []
	var tree := targets[0].get_tree()
	
	match self.target:
		Target.SINGLE_ENEMY:
			assert(targets.size() == 1)
			return targets
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.SINGLE_ENEMY:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []  # Change to assert

func play(targets: Array[Node], character_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	character_stats.mana -= self.cost
	apply_effect(self.get_targets(targets))
	
func apply_effect(targets: Array[Node]) -> void:
	match self.effect:
		EffectKind.DAMAGE:
			var damage_effect := DamageEffect.new()
			damage_effect.amount = self.strength
			damage_effect.execute(targets)
		EffectKind.BLOCK:
			var block_effect := BlockEffect.new()
			block_effect.amount = self.strength
			block_effect.execute(targets)
	
