extends Node2D

@export var _ledge_behavior: EnemyUtils.LedgeBehavior

@onready var _character: Character = get_parent()
@onready var _floor_ray: RayCast2D = $RayCast2D
@onready var _is_patrolling: bool = true

var _direction: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_direction = -1 if _character.is_facing_left() else 1


# Public methods
func pause():
	_is_patrolling = false
	_character.run(0)


func resume():
	_is_patrolling = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _is_patrolling:
		return

	if _character.is_on_wall():
		_direction = sign(_character.get_wall_normal().x)
		_set_floor_ray_position()

	if _character.is_on_floor() && not _floor_ray.is_colliding():
		_ledge_detected()

	_character.run(_direction)


# Private methods
func _set_floor_ray_position():
	@warning_ignore("integer_division")
	_floor_ray.position.x = Global.ppt / 2 * _direction


func _ledge_detected():
	match _ledge_behavior:
		EnemyUtils.LedgeBehavior.TURN_AROUND:
			_direction *= -1
			_set_floor_ray_position()
		EnemyUtils.LedgeBehavior.WALK_OFF:
			return
