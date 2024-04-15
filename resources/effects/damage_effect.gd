class_name DamageEffect
extends Effect

var amount := 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		assert(target != null)
		if target is Enemy or target is Player:
			await target.take_damage(amount)
			SoundEffectsPlayer.play(sound)
