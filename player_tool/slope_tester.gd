extends Node3D

const SLOPE_SCENE: PackedScene = preload("res://model/fake_slope.tscn")

var tool_name: String = "Slope tester"
var tool_description: String = "Create a fake slope for prototyping purposes"

func snap_angle_to_90(angle_radians: float) -> float:
	var abs_angle_degrees = abs(rad_to_deg(angle_radians))
	var bumped = abs_angle_degrees + 45
	var abs_rounded = bumped - fmod(bumped, 90)
	return deg_to_rad(sign(angle_radians) * abs_rounded)

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
		var world_coord = new_voxel * VoxelRenderer.CELL_SIZE
		var slope_scene = SLOPE_SCENE.instantiate()
		slope_scene.position = world_coord + Vector3(VoxelRenderer.CELL_SIZE / 2, VoxelRenderer.CELL_SIZE / 2, VoxelRenderer.CELL_SIZE / 2)
		var player_rotation_y = world.get_node("player").basis.get_euler().y
		var slope_rotation_y = snap_angle_to_90(player_rotation_y)
		slope_scene.rotate_object_local(Vector3(0, 1, 0), slope_rotation_y)
		world.add_child(slope_scene)
