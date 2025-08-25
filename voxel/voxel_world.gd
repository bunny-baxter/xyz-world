extends Node3D

const CHUNK_SIZE: Vector3i = Vector3i(64, 32, 64)

const VOXEL_RENDERER_SCENE: PackedScene = preload("res://voxel/voxel_renderer.tscn")

enum GenerationStyle {
	SUPERFLAT,
	NOISY_MOUNTAINS,
}
@export var generation_style: GenerationStyle = GenerationStyle.SUPERFLAT

func generate_superflat(chunk: VoxelRenderer) -> void:
	for i in range(CHUNK_SIZE.x):
		for j in range(CHUNK_SIZE.z):
			for k in range(10):
				chunk.set_voxel(Vector3i(i, k, j), 1)

func generate_noisy_mountains(chunk: VoxelRenderer) -> void:
	const SMOOTHING_ITERATIONS: int = 7
	const CENTER_WEIGHT: int = 2
	var heights: Array2D = Array2D.new(Vector2i(CHUNK_SIZE.x, CHUNK_SIZE.z))
	# Initialize to random heights
	for i in range(CHUNK_SIZE.x):
		for j in range(CHUNK_SIZE.z):
			heights.set_at(Vector2i(i, j), randi_range(2, 30))
	# Smooth heights
	var get_neighbor = func(array: Array2D, coord: Vector2i):
		if coord.x < 0 or coord.y < 0 or coord.x >= CHUNK_SIZE.x or coord.y >= CHUNK_SIZE.z:
			return 15
		return array.get_at(coord)
	for _i in range(SMOOTHING_ITERATIONS):
		var next_heights = heights.clone()
		for i in range(CHUNK_SIZE.x):
			for j in range(CHUNK_SIZE.z):
				var center = heights.get_at(Vector2i(i, j))
				var north = get_neighbor.call(heights, Vector2i(i, j - 1))
				var south = get_neighbor.call(heights, Vector2i(i, j + 1))
				var east = get_neighbor.call(heights, Vector2i(i - 1, j))
				var west = get_neighbor.call(heights, Vector2i(i + 1, j))
				var average: int = round((center * CENTER_WEIGHT + north + south + east + west) / (4.0 + CENTER_WEIGHT))
				next_heights.set_at(Vector2i(i, j), average)
		heights = next_heights
	# Convert to voxels
	for i in range(CHUNK_SIZE.x):
		for j in range(CHUNK_SIZE.z):
			var height = heights.get_at(Vector2i(i, j))
			for k in range(min(height, CHUNK_SIZE.y - 1)):
				chunk.set_voxel(Vector3i(i, k, j), 1)

func generate_voxels(chunk: VoxelRenderer) -> void:
	if generation_style == GenerationStyle.SUPERFLAT:
		generate_superflat(chunk)
	elif generation_style == GenerationStyle.NOISY_MOUNTAINS:
		generate_noisy_mountains(chunk)

func _ready() -> void:
	var chunk: VoxelRenderer = VOXEL_RENDERER_SCENE.instantiate()
	chunk.position = Vector3(
		-1 * VoxelRenderer.CELL_SIZE * CHUNK_SIZE.x / 2,
		-1 * VoxelRenderer.CELL_SIZE * CHUNK_SIZE.y,
		-1 * VoxelRenderer.CELL_SIZE * CHUNK_SIZE.z / 2)
	chunk.init_voxels(CHUNK_SIZE)
	generate_voxels(chunk)
	chunk.update_geometry()
	add_child(chunk)
