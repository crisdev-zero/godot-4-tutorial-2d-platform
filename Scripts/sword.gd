extends RigidBody2D

@onready var _sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


# Built-in methods
func _ready() -> void:
	# Connect signals
	body_entered.connect(_on_body_entered)


# Public methods
func be_dropped(position_dropped_from: Vector2):
	global_position = position_dropped_from + Vector2.UP * Global.ppt / 2
	apply_impulse(Vector2.UP * Global.ppt * 8 + Vector2.RIGHT * Global.ppt * _rng.randf_range(-1, 1))
	visible = true


# Private methods
func _on_body_entered(body: Node):
	if not body is Hero:
		return

	if !body.can_equip_sword():
		return

	_sfx.play()
	body.equip_sword(self)
	visible = false
	set_deferred("freeze", false)
