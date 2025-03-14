extends Node

func _ready():
	create_mesh_library()

func create_mesh_library():
	var mesh_library = MeshLibrary.new()
	var tile_path = "res://TileTextures/"  # Change this to match your folder path
	var files = DirAccess.open(tile_path)

	if files:
		files.list_dir_begin()
		var file_name = files.get_next()
		var id = 0  # Each tile needs a unique ID

		while file_name != "":
			if file_name.ends_with(".png"):
				var texture_path = tile_path + file_name
				var texture = load(texture_path)

				if texture:
					var material = StandardMaterial3D.new()
					material.albedo_texture = texture

					var quad_mesh = QuadMesh.new()
					quad_mesh.size = Vector2(2, 2)  # Adjust if needed
					quad_mesh.material = material

					mesh_library.create_item(id)
					mesh_library.set_item_mesh(id, quad_mesh)

					print("Added:", file_name, "as tile ID:", id)
					id += 1
			
			file_name = files.get_next()
		
		files.list_dir_end()

		# Save the MeshLibrary for GridMap use
		ResourceSaver.save(mesh_library, "res://tile_library.tres")

		print("MeshLibrary saved successfully!")

	else:
		print("Error: Could not open directory!")
