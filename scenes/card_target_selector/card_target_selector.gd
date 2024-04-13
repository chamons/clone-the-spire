class_name CardTargetSelector
extends Node2D

const ARC_POINTS := 8

@onready var area_2d: Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

var current_card: Card
var targeting := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)

func _process(_delta: float) -> void:
	if not self.targeting:
		return
	self.area_2d.position = get_local_mouse_position()
	self.card_arc.points = self.get_points()

func get_points() -> Array:
	var points := []
	var start := self.current_card.global_position
	start.x += self.current_card.size.x / 2
	var target := get_local_mouse_position()
	var distance := target - start

	for i in ARC_POINTS:
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x, y))
	points.append(target)
	
	return points

func ease_out_cubic(number: float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)
	
func _on_card_aim_started(card: Card) -> void:
	if not card.card.is_single_target(): # Change to assert
		return
	self.targeting = true
	self.area_2d.monitoring = true
	self.area_2d.monitorable = true
	self.current_card = card
	
func _on_card_aim_ended(_card: Card) -> void:
	self.targeting = false
	self.card_arc.clear_points()
	self.area_2d.position = Vector2.ZERO
	self.area_2d.monitoring = false
	self.area_2d.monitorable = false
	self.current_card = null


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not self.current_card or not self.targeting:
		return
	if not self.current_card.targets.has(area):
		self.current_card.targets.append(area)
	

func _on_area_2d_area_exited(area: Area2D) -> void:
	if not self.current_card or not self.targeting:
		return
	self.current_card.targets.erase(area)
