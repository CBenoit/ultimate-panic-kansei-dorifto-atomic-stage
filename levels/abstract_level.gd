extends Node2D

const road_scn = preload("res://objects/road/road.tscn")

export(int) var road_length = 100000

func _ready():
	var step = $background/road/sprite.get_texture().get_height()
	for i in range(0, road_length / step):
		add_road_at(0, -i * step)

func add_road_at(x, y):
	var inst = road_scn.instance()
	inst.rotation = -PI / 2
	inst.set_position(Vector2(x, y))
	add_child(inst)
