extends Node

var tool_name: String = "Mattock"
var tool_description: String = "Destroy a block"

func apply_tool(world: VoxelWorld, hit_voxel: Vector3i, _hit_normal: Vector3):
	world.set_voxel(hit_voxel, 0)
	world.update_geometry_for_voxel(hit_voxel)
