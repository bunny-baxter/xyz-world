extends Node


func use_tool():
	var collider: CollisionObject3D = $RayCast3D.get_collider()
	if collider:
		var voxel_x = int(collider.position.x / VoxelRenderer.CELL_SIZE)
		var voxel_y = int(collider.position.y / VoxelRenderer.CELL_SIZE)
		var voxel_z = int(collider.position.z / VoxelRenderer.CELL_SIZE)
		var collider_parent = collider.get_parent()
		if collider_parent is BodyParent:
			var chunk_coord = collider_parent.chunk_coord
			voxel_x += chunk_coord.x * VoxelWorld.CHUNK_SIZE.x
			voxel_y += chunk_coord.y * VoxelWorld.CHUNK_SIZE.y
			voxel_z += chunk_coord.z * VoxelWorld.CHUNK_SIZE.z
		return Vector3i(voxel_x, voxel_y, voxel_z)
	else:
		return null
