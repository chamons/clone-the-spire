extends Node

func shake(object: Node2D, strength: float, duration: float = 0.2) -> void:
	if not object:
		return
	var origin_position := object.position
	var shake_count := 10
	var tween := create_tween()
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target := origin_position + strength * shake_offset
		if i % 2 == 0:
			target = origin_position
		tween.tween_property(object, "position", target, duration / float(shake_count))
		strength *= 0.75
	tween.finished.connect(func(): object.position = origin_position)
