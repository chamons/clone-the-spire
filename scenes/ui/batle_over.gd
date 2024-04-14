class_name BattleOverPanel
extends Panel

enum TYPE { WIN, LOSE }

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton

func _ready() -> void:
	Events.battle_over_screen_requested.connect(show_screen)

func show_screen(text: String, type: TYPE):
	label.text = text
	continue_button.visible = type == TYPE.WIN
	restart_button.visible = type == TYPE.LOSE
	show()
	get_tree().paused = true

func _on_continue_button_pressed() -> void:	
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
