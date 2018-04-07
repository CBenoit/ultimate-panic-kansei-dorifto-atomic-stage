extends Node2D

const ROADSECTION_SCN = preload("res://objects/road/roadsection.tscn")
const GENERATION_ADVANCE = 2000

var generated_until = 0
var level = 1

func _process(delta):
	var step = $background/roadsection/road/sprite.get_texture().get_height()
	while $foreground/kuruma.position.y - GENERATION_ADVANCE < generated_until:
		add_roadsection_at(0, generated_until - step)
		generated_until -= step

func add_roadsection_at(x, y):
	var inst = ROADSECTION_SCN.instance()
	inst.set_position(Vector2(x, y))
	inst.generate_props_at($foreground)
	add_child(inst)
