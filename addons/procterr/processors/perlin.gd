tool
extends Resource

var simplex = OpenSimplexNoise.new()

export(Vector2) var offset = Vector2(0, 0)
export(Vector2) var scale = Vector2(0, 0)
export(int) var octaves = 1 setget octavesSetget
export(float) var persistance = 0 setget persistanceSetget
export(float) var heightScale = 1
export(float) var lacunarity = 2 setget lacunaritySetget

func process(terrain, width, depth):
	for x in range(0, width):
		for y in range(0, depth):
			var vertex = terrain.getTerrainVertexAt(x, y)
			var delta = abs(simplex.get_noise_2d((x + offset.x) * scale.x, (y + offset.y) * scale.y)) * heightScale
			vertex.y += delta
			terrain.setTerrainVertexAt(x, y, vertex)
	
func octavesSetget(value):
	octaves = value
	simplex.octaves = value
	
func persistanceSetget(value):
	persistance = value
	simplex.persistence = value
	
func lacunaritySetget(value):
	lacunarity = value
	simplex.lacunarity = value
	