extends Node3D

var tool_name: String = "Brick layer"
var tool_description: String = "Create a brick block"

func apply_tool(world: VoxelWorld, hit_voxel: Vector3i, hit_normal: Vector3):
	var delta = Vector3i.ZERO
	if abs(hit_normal.x) > abs(hit_normal.y) and abs(hit_normal.x) > abs(hit_normal.z):
		delta.x = sign(hit_normal.x)
	elif abs(hit_normal.y) > abs(hit_normal.z):
		delta.y = sign(hit_normal.y)
	else:
		delta.z = sign(hit_normal.z)
	if delta != Vector3i.ZERO:
		var new_voxel = hit_voxel + delta
		world.set_voxel(new_voxel, 1)
		world.update_geometry_for_voxel(new_voxel)
