extends Node2D

@onready var _pieces : Array[Node] = get_children()

func scatter():
	for piece in _pieces:
		piece.visible = true
		piece.freeze = false
		piece.apply_impulse(piece.position.normalized() * Global.ppt * 4)
