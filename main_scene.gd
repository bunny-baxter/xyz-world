extends Node3D

const TOOL_HUD_SCENE: PackedScene = preload("res://control/tool_hud.tscn")

@onready var voxel_world: VoxelWorld = $voxel_world
@onready var player: Player = $voxel_world/player
@onready var tools_hud = $tools_hud

func _ready() -> void:
	var player_spawn_y = 0
	while voxel_world.get_voxel(Vector3i(0, player_spawn_y, 0)) > 0:
		player_spawn_y += 1
	player.position = Vector3(
		VoxelRenderer.CELL_SIZE / 2,
		player_spawn_y * VoxelRenderer.CELL_SIZE + 0.475,
		VoxelRenderer.CELL_SIZE / 2)
	var tool_y: int = 0
	for tool in player.get_node("tools").get_children():
		var tool_hud = TOOL_HUD_SCENE.instantiate()
		tools_hud.add_child(tool_hud)
		tool_hud.position.y = tool_y
		tool_hud.set_tool_name(tool.tool_name)
		tool_hud.set_tool_description(tool.tool_description)
		tool_y += 118
	_on_player_active_tool_updated()

func _on_player_active_tool_updated() -> void:
	var t = tools_hud.get_children()
	for i in range(t.size()):
		t[i].active = i == player.active_tool_index
