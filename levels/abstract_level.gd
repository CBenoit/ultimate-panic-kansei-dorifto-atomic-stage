extends Node2D

const ROADSECTION_SCN = preload("res://objects/road/roadsection.tscn")
const GENERATION_ADVANCE = 1500

var generated_until = 0

func _process(delta):
	if $layer_3/kuruma == null:
		return

	var step = $layer_1/roadsection/road/sprite.get_texture().get_width()
	while $layer_3/kuruma.position.y - GENERATION_ADVANCE < generated_until:
		add_roadsection_at(0, generated_until - step)
		generated_until -= step

func add_roadsection_at(x, y):
	var inst = ROADSECTION_SCN.instance()
	inst.set_position(Vector2(x, y))
	inst.generate_props_at($layer_2)
	add_child(inst)
