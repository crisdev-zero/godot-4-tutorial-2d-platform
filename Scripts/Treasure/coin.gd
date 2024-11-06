extends Treasure

@export var _value: int = 1

# Built-in methods
func _ready() -> void:
	# Connect signals
	connect("body_entered", _on_body_entered)


#region Private methods
func _collect():
	# Avoid this, use a signal instead. Never call a parent from a child or encapsulation will be broken
	$/root/Game.collect_coin(_value)
	
	call_deferred("set_freeze_enabled", true)
	call_deferred("set_freeze_mode", RigidBody2D.FREEZE_MODE_STATIC)
	
#endregion
