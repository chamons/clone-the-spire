class_name IntentUI
extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var number: Label = $Number

func update_intent(intent: Intent) -> void:
	icon.texture = intent.icon
	icon.visible = icon.texture != null
	number.text = intent.number
	number.visible = number.text.length() > 0
	show()
