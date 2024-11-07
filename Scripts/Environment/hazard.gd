extends Node

@export_range(1, 100) var _damage: int = 1

@onready var _hit_box = $HitBox


# Built-in methods
func _ready() -> void:
	# Connect signals
	_hit_box.area_entered.connect(_on_hit_box_area_entered)


# Private methods
func _on_hit_box_area_entered(area: Area2D):
	area.get_parent().take_damage(_damage)
