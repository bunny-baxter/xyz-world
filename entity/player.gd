extends CharacterBody3D
class_name Player

@onready var tools = $tools

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed: float = 2.5
@export var jump_speed: float = 3.5
@export var mouse_sensitivity: float = 0.002

signal active_tool_updated;

var active_tool_index: int = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func maybe_switch_active_tool(index: int):
	if tools.get_children().size() > index and active_tool_index != index:
		active_tool_index = index
		active_tool_updated.emit()

func _input(event):
	if event.is_action_pressed("release_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("click_left"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_viewport().set_input_as_handled()
		else:
			use_tool()
	if event.is_action_pressed("switch_to_tool_1"):
		maybe_switch_active_tool(0)
	if event.is_action_pressed("switch_to_tool_2"):
		maybe_switch_active_tool(1)
	if event.is_action_pressed("switch_to_tool_3"):
		maybe_switch_active_tool(2)
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))
		$tool_raycast.rotation.x = $Camera3D.rotation.x

func _physics_process(delta):
	velocity.y += -gravity * delta
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var input: Vector2 = Input.get_vector("strafe_left", "strafe_right", "walk_forward", "walk_backward")
		var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	move_and_slide()
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed

func tool_raycast():
	var collider: CollisionObject3D = $tool_raycast.get_collider()
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

func use_tool():
	var hit_voxel = tool_raycast()
	if hit_voxel != null:
		tools.get_children()[active_tool_index].apply_tool(get_parent(), hit_voxel, $tool_raycast.get_collision_normal())
