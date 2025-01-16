@tool
extends EditorScript

var limit = -1

var meshes_path = "res://assets/models/level_parts/"
var level_parts_path = "res://scenes/level_parts/"

var subfolders = ["in", "ex", "p", "rv", "tr"]

func _run():
	for file_name in DirAccess.get_files_at(meshes_path):
		if (file_name.get_extension() == "res"):
			#skins.append(load("res://assets/skins/"+file_name))
			print("---\nFound mesh "+file_name)
			create_concave_collision_level_part(load(meshes_path+file_name), file_name)
			limit -= 1
			if limit == 0:
				break

# strip level_parts_ from beginning and .res from end
func extract_name(str: String):
	#return file_name.replace(".res","").replace("level_parts_",""))
	return str.substr(12, str.length()-16)

func get_destination_path(str: String):
	var ret = level_parts_path
	for prefix in subfolders:
		if str.substr(0,prefix.length()+1) == prefix + "_":
			ret += prefix + "/"
	return ret + str + ".tscn"

func create_concave_collision_level_part(mesh: Mesh, mesh_file_name: String):
	var extracted_name = extract_name(mesh_file_name)
	var save_path = get_destination_path(extracted_name)
	
	var static_body = StaticBody3D.new()
	static_body.name = extracted_name
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = "MeshInstance3D"
	mesh_instance.mesh = mesh
	static_body.add_child(mesh_instance)
	mesh_instance.owner = static_body
	
	var collision_shape = CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	collision_shape.shape = mesh.create_trimesh_shape()
	static_body.add_child(collision_shape)
	collision_shape.owner = static_body
	
	save_packed_scene(static_body, extracted_name, save_path)
	
func save_packed_scene(node: Node, name: String, path: String):
	print("Saving at " + path)
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	packed_scene.resource_name = name
	ResourceSaver.save(packed_scene, path)
