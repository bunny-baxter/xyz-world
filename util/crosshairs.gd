extends Sprite2D

func _ready():
	center_self()
	get_viewport().size_changed.connect(center_self)

func center_self():
	position = get_viewport().size / 2
