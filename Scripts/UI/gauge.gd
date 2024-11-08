extends Control

@export var _max_pixels: int = 75

@onready var _fill: TextureRect = $Fill


# Public methods
func set_value(percentage: float):
	_fill.size.x = _max_pixels * percentage


# Private methods
func _on_character_health_changed(percentage: float) -> void:
	set_value(percentage)
