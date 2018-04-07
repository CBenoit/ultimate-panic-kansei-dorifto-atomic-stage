extends Node2D

const road_scn = preload("res://objects/road/roadsection.tscn")

export(int) var road_length = 100000

func _ready():
	var step = $background/road/sprite.get_texture().get_height()
	for i in range(1, road_length / step):
		add_road_at(0, -i * step)

func add_road_at(x, y):
	var inst = road_scn.instance()
	inst.set_position(Vector2(x, y))
	add_child(inst)
