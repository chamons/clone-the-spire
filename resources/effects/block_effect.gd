class_name BlockEffect
extends Effect

var amount := 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		assert(target != null)
		if target is Enemy or target is Player:
			target.stats.block += amount
			SoundEffectsPlayer.play(sound)
