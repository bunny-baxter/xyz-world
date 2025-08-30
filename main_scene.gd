extends Node3D

func _ready() -> void:
	var player_spawn_y = 0
	while $voxel_world.get_voxel(Vector3i(0, player_spawn_y, 0)) > 0:
		player_spawn_y += 1
	$player.position = Vector3(
		VoxelRenderer.CELL_SIZE / 2,
		player_spawn_y * VoxelRenderer.CELL_SIZE + 0.475,
		VoxelRenderer.CELL_SIZE / 2)
