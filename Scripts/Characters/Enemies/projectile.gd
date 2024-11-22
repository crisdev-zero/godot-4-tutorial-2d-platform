extends Area2D

@export var _destroyed: Texture2D
@export var _flip_with_direction: bool

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _timer: Timer = $Timer
@onready var _debris: Node2D = $Debris

var _direction: Vector2
var _speed: float
var _damage: int
var _is_destroyed: bool


# Built-in methods
func _process(delta: float) -> void:
	if not _is_destroyed:
		position += _direction * _speed * delta


# Public methods
func fire(direction: Vector2, speed: float, damage: int, duration: float):
	_direction = direction
	if _flip_with_direction and _direction.x > 0:
		scale.x = -1
	_speed = speed
	_damage = damage

	if duration > 0:
		_timer.start(duration)


# Private methods
func _break():
	_sprite.texture = _destroyed
	_is_destroyed = true
	collision_mask = 0

	_timer.timeout.disconnect(_on_timer_timeout)

	_timer.start(0.1)
	await _timer.timeout
	_sprite.visible = false
	_debris.scatter()
	_timer.start(10)
	await _timer.timeout
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	var _character = area.get_parent()
	if _character is Hero:
		_character.take_damage(_damage, (area.global_position - global_position).normalized())
		_break()


func _on_body_entered(_body: Node2D) -> void:
	_break()


func _on_timer_timeout() -> void:
	_break()
