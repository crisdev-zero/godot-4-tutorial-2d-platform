class_name BossEncounter extends Area2D

@export var _boss_music : AudioStream
var _level_music : AudioStream
@export var _bosses : Array[Enemy]
@onready var _camera : Camera2D = $/root/Game/Camera2D
@onready var _camera_marker : Marker2D = $CameraMarker
@onready var _health_gauge : Control = $CanvasLayer/HealthGauge
@onready var _reward : Treasure = get_parent().get_node("Checkpoints/End")
var _hero : Hero
var _current_health : int
var _max_health : int

func _ready():
	for boss in _bosses:
		_max_health += boss._max_health
		boss.health_changed.connect(_update_health_gauge)
	_current_health = _max_health

func _update_health_gauge(_p : float):
	_current_health = 0
	for boss in _bosses:
		_current_health += boss._current_health
	var percentage : float = float(_current_health) / _max_health
	_health_gauge.set_value(percentage)
	if _current_health == 0:
		_on_boss_defeated()
	else:
		_phase_check(percentage)

func _decide_next_attack():
	pass

func _phase_check(_percentage : float):
	pass

func _start_encounter():
	_level_music = Music.stream
	Music.start_track(_boss_music)
	_camera.pan_to_marker(_camera_marker)
	_health_gauge.visible = true

func _end_encounter():
	Music.start_track(_level_music)
	_camera.follow_subject()
	_health_gauge.visible = false

func _on_boss_defeated():
	_end_encounter()
	_reward.reveal(_camera_marker.global_position)

func _on_body_entered(body : Node2D):
	if body is Hero:
		_hero = body
		_start_encounter()

func _on_body_exited(body : Node2D):
	if body == _hero:
		_end_encounter()
