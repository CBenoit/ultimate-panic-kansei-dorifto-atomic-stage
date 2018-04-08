extends KinematicBody2D

const explosion = preload("res://effects/explosion_effect.tscn")

func destroy():
	var inst = explosion.instance()
	inst.set_position(get_position())
	get_parent().add_child(inst)
	inst.set_texture($sprite.get_texture())
	inst.activate()
	queue_free()
