extends Camera3D

const FORWARD_SPEED: float = 1.75
const STRAFE_SPEED: float = 0.75
const ROTATE_SPEED: float = 0.9
const HOVER_SPEED: float = 1.5

var x_rotation = 0.0
var y_rotation = 0.0


func _ready() -> void:
	var angles = basis.get_euler()
	x_rotation = angles.x
	y_rotation = angles.y


func _process(delta) -> void:
	var y_rotate: float = Input.get_axis("camera_rotate_right", "camera_rotate_left")
	y_rotation += y_rotate * delta * ROTATE_SPEED
	var x_rotate: float = Input.get_axis("camera_rotate_down", "camera_rotate_up")
	x_rotation += x_rotate * delta * ROTATE_SPEED
	self.basis = Basis()
	rotate_object_local(Vector3(0, 1, 0), y_rotation)
	rotate_object_local(Vector3(1, 0, 0), x_rotation)

	var x_move: float = Input.get_axis("camera_strafe_right", "camera_strafe_left")
	var z_move: float = Input.get_axis("camera_backward", "camera_forward")
	var y_move: float = Input.get_axis("camera_hover_down", "camera_hover_up")
	self.position += -self.basis.z * z_move * delta * FORWARD_SPEED - self.basis.x * x_move * delta * STRAFE_SPEED
	self.position.y += y_move * delta * HOVER_SPEED
