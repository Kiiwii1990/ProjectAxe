@tool
extends MeshInstance3D

@export var size_x: int = 50  # Grid width (number of tiles)
@export var size_z: int = 50  # Grid depth
@export var tile_size: float = 1.0  # Distance between vertices

var terrain_mesh: ArrayMesh = ArrayMesh.new()
var surface_tool: SurfaceTool = SurfaceTool.new()
var vertices = []  # Store vertices for editing later

func _ready():
	print("Generating flat triangular grid...")
	var size_x = 20  # Number of quads in X direction
	var size_z = 20  # Number of quads in Z direction
	var spacing = 1.0  # Distance between vertices

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for x in range(size_x):
		for z in range(size_z):
			var v0 = Vector3(x * spacing, 0, z * spacing)
			var v1 = Vector3((x + 1) * spacing, 0, z * spacing)
			var v2 = Vector3(x * spacing, 0, (z + 1) * spacing)
			var v3 = Vector3((x + 1) * spacing, 0, (z + 1) * spacing)

			# First triangle
			st.add_vertex(v0)
			st.add_vertex(v1)
			st.add_vertex(v2)

			# Second triangle
			st.add_vertex(v1)
			st.add_vertex(v3)
			st.add_vertex(v2)

	st.generate_normals()
	var grid_mesh = ArrayMesh.new()
	st.commit(grid_mesh)
	mesh = grid_mesh  # Assign the mesh to MeshInstance3D

	print("Flat grid generated.")



func generate_flat_grid():
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Generate a grid of vertices
	for x in range(size_x + 1):
		var row = []
		for z in range(size_z + 1):
			var vertex = Vector3(x * tile_size, 0, z * tile_size)  # Y = 0 for flat start
			row.append(vertex)
		vertices.append(row)

	# Create triangles from the vertex grid
	for x in range(size_x):
		for z in range(size_z):
			var v1 = vertices[x][z]
			var v2 = vertices[x + 1][z]
			var v3 = vertices[x][z + 1]
			var v4 = vertices[x + 1][z + 1]

			# First triangle (v1, v2, v3)
			surface_tool.add_vertex(v1)
			surface_tool.add_vertex(v2)
			surface_tool.add_vertex(v3)

			# Second triangle (v2, v4, v3)
			surface_tool.add_vertex(v2)
			surface_tool.add_vertex(v4)
			surface_tool.add_vertex(v3)

	surface_tool.generate_normals()  # Ensure proper lighting
	surface_tool.commit(terrain_mesh)  # Save to mesh
	mesh = terrain_mesh  # Apply it to MeshInstance3D
