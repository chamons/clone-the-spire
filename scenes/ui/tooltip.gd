class_name Tooltip
extends PanelContainer

@onready var tooltip_text_label: RichTextLabel = %TooltipText
@onready var tooltip_icon: TextureRect = %TooltipIcon

@export var fade_seconds := 0.2

var tween: Tween
var toolip_is_visible := false

func _ready() -> void:
	Events.card_tooltip_requested.connect(func(card): show_tooltip(card.card.icon, card.card.tooltip))
	Events.card_tooltip_hide_requested.connect(hide_tooltip)
	self.modulate = Color.TRANSPARENT
	hide()

func show_tooltip(icon: Texture, text: String) -> void:
	self.toolip_is_visible = true
	if self.tween:
		self.tween.kill()
	self.tooltip_icon.texture = icon
	self.tooltip_text_label.text = text
	self.tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	self.tween.tween_callback(self.show)
	self.tween.tween_property(self, "modulate", Color.WHITE, self.fade_seconds)

func hide_tooltip() -> void:
	self.toolip_is_visible = false
	if self.tween:
		self.tween.kill()
	self.get_tree().create_timer(fade_seconds, false).timeout.connect(hide_animation)

func hide_animation() -> void:
	if not self.toolip_is_visible:
		self.tween = self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		self.tween.tween_property(self, "modulate", Color.TRANSPARENT, self.fade_seconds)
		self.tween.tween_callback(self.hide)
