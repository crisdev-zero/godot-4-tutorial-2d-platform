extends Node2D

@export var _victory : AudioStream
@export var _death : AudioStream
@export var _gameover : AudioStream
@onready var _camera : Camera2D = $Camera2D
@onready var _player_character : CharacterBody2D = $Roger
@onready var _player : Node = $Roger/Player
@onready var _level : Area2D = $Level
@onready var _coin_counter : Control = $UserInterface/CoinCounter
@onready var _lives_counter : Control = $UserInterface/LivesCounter
@onready var _key_icon : Control = $UserInterface/KeyIcon
@onready var _game_over_menu : Control = $UserInterface/GameOverMenu
@onready var _fade : ColorRect = $UserInterface/Fade
@onready var _fanfare : AudioStreamPlayer = $Fanfare

# Called when the node enters the scene tree for the first time.
func _ready():
	_fade.visible = true
	_init_boundaries()
	_init_ui()
	_spawn_player()
	await _fade.fade_to_clear()
	_player.set_enabled(true)

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
	_game_over_menu.visible = false

func _spawn_player():
	_player_character.global_position = _level.get_checkpoint_position(File.data.checkpoint)
	_player_character.velocity = Vector2.ZERO

func collect_map():
	_player.set_enabled(false)
	_fanfare.stream = _victory
	_fanfare.play()
	await _fanfare.finished
	await _fade.fade_to_black()
	# load level selection scene

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

func _on_retry_pressed():
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	File.data.retry()
	_level.queue_free()
	_level = load("res://Scenes/Levels/level_" + str(File.data.world) + "-" + str(File.data.level) + ".tscn").instantiate()
	add_child(_level)
	_spawn_player()
	_player.set_enabled(false)
	_player_character.revive()
	await _fade.fade_to_clear()
	_player.set_enabled(true)

func _on_level_select_pressed():
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	File.data.retry()
	print("Return to level selection menu")

func _on_exit_pressed():
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	get_tree().quit()
	# or return to title screen
