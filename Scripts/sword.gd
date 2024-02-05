extends RigidBody2D

@onready var _sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

func be_dropped(position_dropped_from : Vector2):
	global_position = position_dropped_from + Vector2.UP * Global.ppt / 2
	apply_impulse(Vector2.UP * Global.ppt * 8 + Vector2.RIGHT * Global.ppt * _rng.randf_range(-1, 1))
	visible = true

func _on_body_entered(body : Node):
	if body is Hero && body.can_equip_sword():
		_sfx.play()
		body.equip_sword(self)
		visible = false
		set_deferred("freeze", false)
