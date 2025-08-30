extends Node3D

const CHUNK_SIZE: Vector3i = Vector3i(16, 16, 16)

const VOXEL_RENDERER_SCENE: PackedScene = preload("res://voxel/voxel_renderer.tscn")

enum GenerationStyle {
	SUPERFLAT,
	NOISY_MOUNTAINS,
}
@export var generation_style: GenerationStyle = GenerationStyle.SUPERFLAT

var chunks: Dictionary = {}

func voxel_to_chunk(global_voxel: Vector3i):
	var chunk_coord = Vector3i(
		floor(global_voxel.x / float(CHUNK_SIZE.x)),
		floor(global_voxel.y / float(CHUNK_SIZE.y)),
		floor(global_voxel.z / float(CHUNK_SIZE.z)))
	var local_voxel = Vector3i(
		global_voxel.x - chunk_coord.x * CHUNK_SIZE.x,
		global_voxel.y - chunk_coord.y * CHUNK_SIZE.y,
		global_voxel.z - chunk_coord.z * CHUNK_SIZE.z)
	return [ chunk_coord, local_voxel ]

func get_voxel(global_voxel: Vector3i) -> int:
	var chunk_location = voxel_to_chunk(global_voxel)
	var chunk_coord = chunk_location[0]
	var local_voxel = chunk_location[1]
	if not chunk_coord in chunks:
		return 0
	return chunks[chunk_coord].get_voxel(local_voxel)

func set_voxel(global_voxel: Vector3i, value: int):
	var chunk_location = voxel_to_chunk(global_voxel)
	var chunk_coord = chunk_location[0]
	var local_voxel = chunk_location[1]
	if not chunk_coord in chunks:
		var chunk: VoxelRenderer = VOXEL_RENDERER_SCENE.instantiate()
		chunk.position = Vector3(
			VoxelRenderer.CELL_SIZE * CHUNK_SIZE.x * chunk_coord.x,
			VoxelRenderer.CELL_SIZE * CHUNK_SIZE.y * chunk_coord.y,
			VoxelRenderer.CELL_SIZE * CHUNK_SIZE.z * chunk_coord.z)
		chunk.init_voxels(CHUNK_SIZE)
		chunks[chunk_coord] = chunk
		add_child(chunk)
	return chunks[chunk_coord].set_voxel(local_voxel, value)

func generate_superflat() -> void:
	for i in range(-32, 32):
		for j in range(-16, 16):
			for k in range(0, 10):
				set_voxel(Vector3i(i, k, j), 1)

func generate_noisy_mountains() -> void:
	const SIZE: Vector2i = Vector2i(128, 128)
	const SMOOTHING_ITERATIONS: int = 4
	const CENTER_WEIGHT: int = 2
	var heights: Array2D = Array2D.new(SIZE)
	# Initialize to random heights
	for i in range(SIZE.x):
		for j in range(SIZE.y):
			heights.set_at(Vector2i(i, j), randi_range(2, 31))
	# Smooth heights
	var get_neighbor = func(array: Array2D, coord: Vector2i):
		if coord.x < 0 or coord.y < 0 or coord.x >= SIZE.x or coord.y >= SIZE.y:
			return 15
		return array.get_at(coord)
	for _i in range(SMOOTHING_ITERATIONS):
		var next_heights = heights.clone()
		for i in range(SIZE.x):
			for j in range(SIZE.y):
				var center = heights.get_at(Vector2i(i, j))
				var north = get_neighbor.call(heights, Vector2i(i, j - 1))
				var south = get_neighbor.call(heights, Vector2i(i, j + 1))
				var east = get_neighbor.call(heights, Vector2i(i - 1, j))
				var west = get_neighbor.call(heights, Vector2i(i + 1, j))
				var average: int = round((center * CENTER_WEIGHT + north + south + east + west) / (4.0 + CENTER_WEIGHT))
				next_heights.set_at(Vector2i(i, j), average)
		heights = next_heights
	# Convert to voxels
	for i in range(SIZE.x):
		for j in range(SIZE.y):
			var height = heights.get_at(Vector2i(i, j))
			for k in range(height):
				@warning_ignore("integer_division")
				set_voxel(Vector3i(i - SIZE.x / 2, k, j - SIZE.y / 2), 1)

func generate_voxels() -> void:
	if generation_style == GenerationStyle.SUPERFLAT:
		generate_superflat()
	elif generation_style == GenerationStyle.NOISY_MOUNTAINS:
		generate_noisy_mountains()

func _ready() -> void:
	generate_voxels()
	for coord in chunks:
		var chunk: VoxelRenderer = chunks[coord]
		chunk.update_geometry()
		chunk.load_shader()

func _on_player_destroy_voxel(voxel_coord: Vector3i) -> void:
	# TODO: voxel_coord is incorrect now
	print(str(voxel_coord))
	#var chunk = $chunk
	#chunk.set_voxel(voxel_coord, 0)
	#chunk.update_geometry()
