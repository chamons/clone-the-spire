class_name BlockEffect
extends Effect

var amount := 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		# Change to assert
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.block += amount
