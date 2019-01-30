tool
extends EditorPlugin

export(Vector2) var size = Vector2(100, 100) setget setSize
export(Array) var processors = []

var meshDataTool = MeshDataTool.new()
var surfaceTool = SurfaceTool.new()
var mesh = PlaneMesh.new()


func _enter_tree():
    # Initialization of the plugin goes here
	print("Init terrain")
	add_custom_type("Perlin", "Resource", preload("processors/perlin.gd"), preload("default.png"))

func _exit_tree():
    # Clean-up of the plugin goes here
	remove_custom_type("Perlin")

func _ready():
	#print("Init terrain")
	pass
	
func createPlaneMeshAndSetMesh():
	mesh = PlaneMesh.new()
	
func setSize(val):
	size = val
	createPlaneMeshAndSetMesh()
	mesh.subdivide_width = size.x
	mesh.subdivide_depth = size.y
	mesh.size = size
	processTerrain()
	
func processTerrain():
	for p in processors:
		p.process()
	var arrayMesh = createArrayMesh()
	for i in range(meshDataTool.get_vertex_count()):
		var vertex = meshDataTool.get_vertex(i);
		var offset = rand_range(-1, 1)
		vertex.y += offset
		meshDataTool.set_vertex(i, vertex)
	for s in range(arrayMesh.get_surface_count()):
		arrayMesh.surface_remove(s)
	meshDataTool.commit_to_surface(arrayMesh)
	surfaceTool.create_from(arrayMesh, 0)
	surfaceTool.generate_normals()
	$MeshInstance.mesh = surfaceTool.commit()
	
func createArrayMesh():
	surfaceTool.create_from(mesh, 0)
	var arrayMesh = surfaceTool.commit()
	meshDataTool.create_from_surface(arrayMesh, 0)
	return arrayMesh
	
func getTerrainVertexAt(x, y):
	return meshDataTool.get_vertex(meshIndexFromXY(x, y))

func setTerrainVertexAt(x, y, value):
	meshDataTool.set_vertex(meshIndexFromXY(x, y), value)
	
func meshIndexFromXY(x, y):
	return x + (y * mesh.subdivide_depth)
	