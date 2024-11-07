extends Treasure


# Built-in methods
func _ready() -> void:
	# Connect signals
	connect("body_entered", _on_body_entered)


# Private methods
func _collect():
	$/root/Game.collect_key()
