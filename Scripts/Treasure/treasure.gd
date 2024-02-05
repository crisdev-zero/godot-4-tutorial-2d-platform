class_name Treasure extends CollisionObject2D

@onready var _sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var _sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
var _character : Character

func reveal(new_position : Vector2):
	global_position = new_position
	visible = true
	_sprite.play_backwards("effect")
	await _sprite.animation_finished
	_sprite.play("default")

func _collect():
	pass

func _on_body_entered(body : Node):
	_sfx.play()
	if not body is Character:
		return
	_character = body
	collision_mask = 0
	_collect()
	_sprite.play("effect")
	await _sprite.animation_finished
	queue_free()
