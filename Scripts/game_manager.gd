extends Node2D

@export var _victory : AudioStream
@export var _death : AudioStream
@export var _gameover : AudioStream
@onready var _camera : Camera2D = $Camera2D
@onready var _player_character : CharacterBody2D = $Roger
@onready var _player : Node = $Roger/Player
@onready var _coin_counter : Control = $UserInterface/CoinCounter
@onready var _lives_counter : Control = $UserInterface/LivesCounter
@onready var _key_icon : Control = $UserInterface/KeyIcon
@onready var _game_over_menu : Control = $UserInterface/GameOverMenu
@onready var _pause_menu : Control = $UserInterface/PauseMenu
@onready var _fade : ColorRect = $UserInterface/Fade
@onready var _fanfare : AudioStreamPlayer = $Fanfare
var _level : Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_fade.visible = true
	_load_level()
	_spawn_player()
	await _fade.fade_to_clear()
	_player.set_enabled(true)

func _load_level():
	_level = load("res://Scenes/Levels/level_" + str(File.data.world) + "-" + str(File.data.level) + ".tscn").instantiate()
	add_child(_level)
	_init_boundaries()
	_init_ui()
	_pause(false)
	Music.start_track(_level.music)

func _init_boundaries():
	# get the level boundaries from the level
	var min_boundary : Vector2 = _level.get_min()
	var max_boundary : Vector2 = _level.get_max()
	# and tell them to the camera and player character
	_camera.set_bounds(min_boundary, max_boundary)
	_player_character.set_bounds(min_boundary, max_boundary)

func _init_ui():
	#initialize the UI
	_coin_counter.set_value(File.data.coins)
	_lives_counter.set_value(File.data.lives)
	_key_icon.visible = File.data.has_key
	_game_over_menu.visible = false

func _spawn_player():
	_player_character.global_position = _level.get_checkpoint_position(File.data.checkpoint)
	_player_character.velocity = Vector2.ZERO

func _input(event : InputEvent):
	if event.is_action_pressed("pause"):
		_pause(!get_tree().paused)

func _pause(should_be_paused : bool):
	get_tree().paused = should_be_paused
	_pause_menu.visible = should_be_paused

func collect_map():
	_player.set_enabled(false)
	File.data.set_progress_marker(Data.Progress.COMPLETED)
	File.data.set_progress_marker(Data.Progress.UNLOCKED, _level.world_unlocked, _level.level_unlocked)
	_fanfare.stream = _victory
	_fanfare.play()
	await _fanfare.finished
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

func collect_coin(value : int):
	File.data.coins += value
	if File.data.coins >= 100:
		File.data.coins -= 100
		File.data.lives += 1
		_lives_counter.set_value(File.data.lives)
	_coin_counter.set_value(File.data.coins)

func collect_skull():
	File.data.lives += 1
	_lives_counter.set_value(File.data.lives)

func collect_key():
	File.data.has_key = true
	_key_icon.visible = true

func use_key():
	File.data.has_key = false
	_key_icon.visible = false

func _on_player_died():
	if File.data.lives == 0:
		_game_over()
	else:
		File.data.lives -= 1
		_lives_counter.set_value(File.data.lives)
		_fanfare.stream = _death
		_fanfare.play()
		_return_to_last_checkpoint()

func _return_to_last_checkpoint():
	_player.set_enabled(false)
	await _fade.fade_to_black()
	_spawn_player()
	_player_character.revive()
	await _fade.fade_to_clear()
	_player.set_enabled(true)

func _game_over():
	_fanfare.stream = _gameover
	_fanfare.play()
	_game_over_menu.visible = true

func _restart(game_over : bool = false):
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	File.data.reset(game_over)
	_level.queue_free()
	_load_level()
	_spawn_player()
	_player.set_enabled(false)
	_player_character.revive()
	await _fade.fade_to_clear()
	_player.set_enabled(true)

func _on_level_select_pressed():
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

func _on_exit_pressed():
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/title.tscn")
