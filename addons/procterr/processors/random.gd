tool
extends Resource

export(Vector2) var minimumMaximum = Vector2(0, 1)

func process(terrain, width, depth):
	for x in range(0, width):
		for y in range(0, depth):
			var vertex = terrain.getTerrainVertexAt(x, y)
			var delta = rand_range(minimumMaximum.x, minimumMaximum.y)
			vertex.y += delta
			terrain.setTerrainVertexAt(x, y, vertex)
	