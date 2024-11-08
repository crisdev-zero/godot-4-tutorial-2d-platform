extends CollisionObject2D
class_name Treasure

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _character: Character


# Built-in methods
func _ready() -> void:
	# Connect signals
	pass


#region Private methods - Signals connect
func _on_body_entered(body: Node):
	if not body is Character:
		return

	_character = body
	# Prevent multiple collisions with the player
	collision_mask = 0

	_collect()

	_sfx.play()

	_sprite.play("effect")
	await _sprite.animation_finished

	queue_free()


#endregion


#region Private methods
func _collect():
	pass

#endregion
