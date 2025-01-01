extends Node2D

@onready var _fade: ColorRect = $CanvasLayer/Fade


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fade.visible = true
	_fade.fade_to_clear()


func _on_level_selected(world: int, level: int):
	File.data.world = world
	File.data.level = level
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
