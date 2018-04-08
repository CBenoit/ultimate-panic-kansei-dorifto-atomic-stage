extends Node2D

const PROP_SCN = preload("res://objects/props/prop.tscn")

const NUM_PROPS = 6
const NUM_TRAPS = 1

func generate_props_at(node):
	_generate_props_in_grass_at($grass, node)
	_generate_props_in_grass_at($grass2, node)

func _generate_props_in_grass_at(grass, node):
	for i in range(0, NUM_PROPS):
		var x = grass.position.x + rand_range(-1, 1) * $grass.get_texture().get_width() / 2.6
		var y = position.y + rand_range(-1, 1) * $grass.get_texture().get_height() / 2
		var prop = PROP_SCN.instance()
		prop.set_position(Vector2(x, y))
		prop.set_frame(randi() % 6)
		node.add_child(prop)
