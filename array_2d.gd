extends Resource
class_name Array2D

var size: Vector2i = Vector2i(0, 0)
var data: PackedInt32Array = []

func _init(_size: Vector2i) -> void:
	size = _size
	var flat_size = size.x * size.y
	data.resize(flat_size)
	data.fill(0)

func coord_to_index(coord: Vector2i) -> int:
	return coord.y * size.x + coord.x

func get_at(coord: Vector2i) -> int:
	return data[coord_to_index(coord)]

func set_at(coord: Vector2i, value: int) -> void:
	data[coord_to_index(coord)] = value

func clone() -> Array2D:
	var c = Array2D.new(size)
	for i in range(size.x * size.y):
		c.data[i] = data[i]
	return c
