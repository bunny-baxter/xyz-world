extends Node3D
class_name VoxelRenderer

const CELL_SIZE: float = 0.5

## VOXEL FUNCTIONS

var voxels_size: Vector3i
var voxels: PackedInt32Array = []

func init_voxels(size: Vector3i):
	voxels_size = size
	var flat_size = size.x * size.y * size.z
	voxels.resize(flat_size)
	voxels.fill(0)

func coord_to_index(coord: Vector3i) -> int:
	return coord.z * (voxels_size.x * voxels_size.y) + coord.y * voxels_size.x + coord.x

func index_to_coord(index: int) -> Vector3i:
	@warning_ignore("integer_division")
	var z = index / (voxels_size.x * voxels_size.y)
	var remainder = index % (voxels_size.x * voxels_size.y)
	@warning_ignore("integer_division")
	var y = remainder / voxels_size.x
	var x = remainder % voxels_size.x
	return Vector3i(x, y, z)

func is_coord_out_of_bounds(coord: Vector3i) -> bool:
	return coord.x < 0 or coord.y < 0 or coord.z < 0 or coord.x >= voxels_size.x or coord.y >= voxels_size.y or coord.z >= voxels_size.z

func get_voxel(coord: Vector3i) -> int:
	if is_coord_out_of_bounds(coord):
		return 0
	return voxels[coord_to_index(coord)]

func set_voxel(coord: Vector3i, item: int):
	voxels[coord_to_index(coord)] = item

## NODE FUNCTIONS

func create_cube(offset: Vector3,
				 verts: PackedVector3Array,
				 uvs: PackedVector2Array,
				 normals: PackedVector3Array,
				 render_posx_face: bool,
				 render_negx_face: bool,
				 render_posy_face: bool,
				 render_negy_face: bool,
				 render_posz_face: bool,
				 render_negz_face: bool,
				 add_collision: bool):
	#      +Y
	#       |
	#       2 -------- 6
	#      /|         /|
	#     / |        / |
	#    4 -------- 7  |
	#    |  |       |  |
	#    |  0 ------|- 3 --- +X
	#    | /        | /
	#    |/         |/
	#    1 -------- 5
	#   /
	# +Z
	if render_negx_face:
		verts.append(Vector3(offset.x, offset.y, offset.z)) # 0
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 4
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x, offset.y, offset.z + CELL_SIZE)) # 1
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x, offset.y, offset.z)) # 0
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z)) # 2
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 4
		uvs.append(Vector2(1, 0))
		for _i in range(6):
			normals.append(Vector3(-1.0, 0.0, 0.0))

	if render_negy_face:
		verts.append(Vector3(offset.x, offset.y, offset.z)) # 0
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x, offset.y, offset.z + CELL_SIZE)) # 1
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z + CELL_SIZE)) # 5
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x, offset.y, offset.z)) # 0
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z + CELL_SIZE)) # 5
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z)) # 3
		uvs.append(Vector2(1, 1))
		for _i in range(6):
			normals.append(Vector3(0.0, -1.0, 0.0))

	if render_negz_face:
		verts.append(Vector3(offset.x, offset.y, offset.z)) # 0
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z)) # 3
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z)) # 6
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x, offset.y, offset.z)) # 0
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z)) # 6
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z)) # 2
		uvs.append(Vector2(1, 0))
		for _i in range(6):
			normals.append(Vector3(0.0, 0.0, -1.0))

	if render_posx_face:
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 7
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z)) # 6
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z)) # 3
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 7
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z)) # 3
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z + CELL_SIZE)) # 5
		uvs.append(Vector2(0, 1))
		for _i in range(6):
			normals.append(Vector3(1.0, 0.0, 0.0))

	if render_posy_face:
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 7
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z)) # 2
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z)) # 6
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 7
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 4
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z)) # 2
		uvs.append(Vector2(0, 0))
		for _i in range(6):
			normals.append(Vector3(0.0, 1.0, 0.0))

	if render_posz_face:
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 7
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x, offset.y, offset.z + CELL_SIZE)) # 1
		uvs.append(Vector2(0, 1))
		verts.append(Vector3(offset.x, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 4
		uvs.append(Vector2(0, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y + CELL_SIZE, offset.z + CELL_SIZE)) # 7
		uvs.append(Vector2(1, 0))
		verts.append(Vector3(offset.x + CELL_SIZE, offset.y, offset.z + CELL_SIZE)) # 5
		uvs.append(Vector2(1, 1))
		verts.append(Vector3(offset.x, offset.y, offset.z + CELL_SIZE)) # 1
		uvs.append(Vector2(0, 1))
		for _i in range(6):
			normals.append(Vector3(0.0, 0.0, 1.0))

	if add_collision:
		var collision_shape = CollisionShape3D.new()
		collision_shape.position = Vector3(offset.x + CELL_SIZE / 2.0, offset.y + CELL_SIZE / 2.0, offset.z + CELL_SIZE / 2.0)
		var box_shape = BoxShape3D.new()
		box_shape.size = Vector3(CELL_SIZE, CELL_SIZE, CELL_SIZE)
		collision_shape.shape = box_shape
		$StaticBody3D.add_child(collision_shape)

func update_geometry():
	# TODO: need to clear the mesh first
	var mesh: ArrayMesh = $MeshInstance3D.mesh

	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()

	for index in range(voxels.size()):
		var item = voxels[index]
		if item == 0:
			continue

		var coord = index_to_coord(index)
		var offset = coord * CELL_SIZE
		var render_posx_face = get_voxel(coord + Vector3i(1, 0, 0)) == 0
		var render_negx_face = get_voxel(coord + Vector3i(-1, 0, 0)) == 0
		var render_posy_face = get_voxel(coord + Vector3i(0, 1, 0)) == 0
		var render_negy_face = get_voxel(coord + Vector3i(0, -1, 0)) == 0
		var render_posz_face = get_voxel(coord + Vector3i(0, 0, 1)) == 0
		var render_negz_face = get_voxel(coord + Vector3i(0, 0, -1)) == 0
		var add_collision = render_posx_face or render_negx_face or render_posy_face or render_negy_face or render_posz_face or render_negz_face
		create_cube(offset, verts, uvs, normals, render_posx_face, render_negx_face, render_posy_face, render_negy_face, render_posz_face, render_negz_face, add_collision)

	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

func load_shader():
	var shader_file = FileAccess.open("res://voxel_shader.gdshader", FileAccess.READ)
	var code = shader_file.get_as_text()
	var shader = Shader.new()
	shader.code = code
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	var texture: Texture2D = load("res://textures/Texturelabs_Brick_123S.png")
	shader_material.set_shader_parameter("uv_map", texture)
	$MeshInstance3D.set_surface_override_material(0, shader_material)

func _ready():
	load_shader()
