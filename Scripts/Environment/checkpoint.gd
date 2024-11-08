extends Area2D
class_name Checkpoint

@export var id: int

@onready var _sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Built-in methods
func _ready() -> void:
	# Connect signals
	body_entered.connect(_on_body_entered)


# Private methods
func _on_body_entered(_body: Node2D):
	_sfx.play()
	collision_mask = 0
	File.data.checkpoint = id
