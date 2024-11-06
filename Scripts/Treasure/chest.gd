extends Area2D

@export var _is_open: bool
@export_range(0, 99) var _total_value: int = 1
@export var _silver_coin: PackedScene
@export var _gold_coin: PackedScene

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _booty: Array[Treasure]


# Built-in methods
func _ready() -> void:
	while _total_value > 10:
		_total_value -= 10
		_booty.push_back(_gold_coin.instantiate())

	while _total_value > 0:
		_total_value -= 1
		_booty.push_back(_silver_coin.instantiate())


# Public methods
func plunder():
	for item in _booty:
		item.global_position = global_position + Vector2.UP * Global.ppt
		item.freeze = false

		# apply impulse force
		item.apply_impulse(Vector2.UP * Global.ppt * _rng.randf_range(5, 10) + Vector2.RIGHT * Global.ppt * _rng.randf_range(-1, 1))
		get_parent().add_child(item)

	_booty.clear()


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		_is_open = true
