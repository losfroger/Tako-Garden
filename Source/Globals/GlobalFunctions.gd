extends Node

const WIDTH = ProjectSettings["display/window/size/width"]
const HEIGHT = ProjectSettings["display/window/size/height"]


func randomCord(margin: Vector2 = Vector2.ZERO) -> Vector2:
	return Vector2(
		rand_range(0 + margin.x, WIDTH - margin.x),
		rand_range(0 + margin.y, HEIGHT - margin.y)
	)