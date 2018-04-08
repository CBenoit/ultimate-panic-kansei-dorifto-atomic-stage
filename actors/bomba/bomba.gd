extends KinematicBody2D

const SPEED_NORMAL = 20.0
const MAX_DIST = -1300.0


var kuruma

func _ready():
	kuruma = get_parent().get_parent().get_node("layer_3").get_node("kuruma")
	pass

func _physics_process(delta):
	var dist = kuruma.to_global(Vector2(0, 0)).y - to_global(Vector2(0, 0)).y
	var movement
	if (dist > MAX_DIST):
		movement = Vector2(0,-1) * SPEED_NORMAL
	else:
		movement = Vector2(0,dist - MAX_DIST)*1.5
		
	
	var info = move_and_collide(movement)
	if info != null :
		info.collider.destroy()
