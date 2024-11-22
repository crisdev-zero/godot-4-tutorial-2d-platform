extends Enemy

@export var _projectile: PackedScene
@export_range(0, 100) var _p_speed: float = 10
@export_range(1, 100) var _p_damage: int = 1
@export var _p_duration: float = 10
@export var _wants_to_fire: bool:
	set = set_wants_to_fire

@onready var _p_origin: Node2D = $ProjectileOrigin

var _sprite_x_offset: float


# Built-in methods
func _ready() -> void:
	_sprite_x_offset = _sprite.offset.x
	super._ready()
	_p_speed *= Global.ppt


# Public methods
# @overrides
func face_left():
	super.face_left()
	_sprite.offset.x = _sprite_x_offset * (1 if _sprites_face_left else -1)


# @overrides
func face_right():
	super.face_right()
	_sprite.offset.x = _sprite_x_offset * (-1 if _sprites_face_left else 1)


func set_wants_to_fire(value: bool):
	_wants_to_fire = value


func fire():
	set_wants_to_fire(true)


# Private methods
func _spawn_projectile():
	var projectile = _projectile.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = _p_origin.global_position
	projectile.fire(Vector2.LEFT if _is_facing_left else Vector2.RIGHT, _p_speed, _p_damage, _p_duration)
