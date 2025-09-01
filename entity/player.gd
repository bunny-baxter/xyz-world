extends CharacterBody3D
class_name Player

signal destroy_voxel(voxel_coord: Vector3i)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed: float = 2.5
@export var jump_speed: float = 3.5
@export var mouse_sensitivity: float = 0.002


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event.is_action_pressed("release_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("click_left"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_viewport().set_input_as_handled()
		else:
			var hit_voxel = $tools/mattock.use_tool()
			if hit_voxel != null:
				destroy_voxel.emit(hit_voxel)
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))
		$tools.rotation.x = $Camera3D.rotation.x


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
