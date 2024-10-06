extends Node2D

@export var _music : AudioStream
@onready var _fade : ColorRect = $CanvasLayer/Fade
@onready var _level_buttons : Array[Node] = $CanvasLayer/PanelContainer/VBoxContainer/GridContainer.get_children()

func _ready():
	_fade.visible = true
	var button : int = 0
	for world in File.data.progress.size():
		for level in File.data.progress[world].size():
			_level_buttons[button].visible = File.data.check_progress_marker(Data.Progress.UNLOCKED, world + 1, level + 1)
			button += 1
	get_tree().paused = false
	File.save_game()
	Music.start_track(_music)
	_fade.fade_to_clear()

func _on_level_selected(world : int, level : int):
	File.data.world = world
	File.data.level = level
	File.data.checkpoint = 0
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_exit_pressed():
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title.tscn")
