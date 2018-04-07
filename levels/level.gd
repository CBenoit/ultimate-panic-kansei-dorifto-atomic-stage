extends Node2D

const road_scn = preload("res://objects/road/road.tscn")

export(int) var road_length = 100000

func _ready():
	var x = $road.position.x
	var step = get_node("road/sprite").get_texture().get_height()
	for i in range(1, road_length / step):
		add_road_at(x, -i * step)

func add_road_at(x, y):
	var inst = road_scn.instance()
	inst.rotation = -PI / 2
	inst.set_position(Vector2(x, y))
	add_child(inst)
