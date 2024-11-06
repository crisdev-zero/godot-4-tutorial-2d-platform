extends Treasure

# Built-in methods
func _ready() -> void:
	# Connect signals
	connect("body_entered", _on_body_entered)


#region Private methods
func _collect():
	# Avoid this, use a signal instead. Never call a parent from a child or encapsulation will be broken
	$/root/Game.collect_skull()
	
#endregion
