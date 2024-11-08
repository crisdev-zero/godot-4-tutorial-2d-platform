extends Treasure

@export var _amount_recovered: int = 3


# Built-in methods
func _ready() -> void:
	# Connect signals
	connect("body_entered", _on_body_entered)


# Private methods
func _collect():
	_character.recover(_amount_recovered)
