tool
extends Node

export(Vector2) var size = Vector2(100, 100) setget setSize
export(Array) var processors = []

onready var meshInstance = MeshInstance.new()

var meshDataTool = MeshDataTool.new()
var surfaceTool = SurfaceTool.new()
var mesh = PlaneMesh.new()

func _ready():
	print("init terrain...")
	add_child(meshInstance)

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
	var arrayMesh = createArrayMesh()
	for p in processors:
		p.process(self, size.x, size.y)
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
