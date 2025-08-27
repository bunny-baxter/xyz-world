extends Node


func use_tool():
	var collider: CollisionObject3D = $RayCast3D.get_collider()
	if collider:
		var voxel_x = int(collider.position.x / VoxelRenderer.CELL_SIZE)
		var voxel_y = int(collider.position.y / VoxelRenderer.CELL_SIZE)
		var voxel_z = int(collider.position.z / VoxelRenderer.CELL_SIZE)
		return Vector3i(voxel_x, voxel_y, voxel_z)
	else:
		return null
