extends Node2D

@export var _music : AudioStream
@onready var _fade : ColorRect = $CanvasLayer/Fade
@onready var _continue : Button = $CanvasLayer/Buttons/Continue
@onready var _confirmation : Control = $CanvasLayer/Confirmation

func _ready():
	_fade.visible = true
	get_tree().paused = false
	if File.save_file_exists():
		_continue.disabled = false
	Music.start_track(_music)
	_fade.fade_to_clear()

func _change_scene(path : String):
	await _fade.fade_to_black()
	get_tree().change_scene_to_file(path)

func _on_new_game_pressed():
	if not File.save_file_exists():
		_start_new_game()
	else:
		_confirmation.visible = true

func _start_new_game():
	File.new_game()
	File.save_game()
	_change_scene("res://Scenes/game.tscn")

func _on_continue_pressed():
	File.load_game()
	_change_scene("res://Scenes/level_select.tscn")

func _on_yes_pressed():
	_start_new_game()

func _on_no_pressed():
	_confirmation.visible = false

func _on_exit_pressed():
	Music.stop_track()
	await _fade.fade_to_black()
	get_tree().quit()
