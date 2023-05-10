extends Node


func draw_line(pos1: Vector3, pos2: Vector3) -> void:
	var mesh_instace := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instace.mesh = immediate_mesh
	mesh_instace.material_override = material
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.CORAL
	
	get_tree().root.add_child(mesh_instace)
