extends Position2D

const WOODEN_BOX_SCN = preload("res://actors/wooden_box/wooden_box.tscn")
const METAL_BOX_SCN = preload("res://actors/metal_box/metal_box.tscn")

const MAX_X = 480
const MIN_X = -480

var direction = Vector2(1, 0)
var difficulty = 0.0

func _ready():
	$spawn_timer.connect("timeout", self, "_spawn_trap")

func _process(delta):
	difficulty += 0.0001

	position.x += direction.x * randf() * 200

	if position.x > MAX_X:
		direction = Vector2(-1, 0)
		position.x = MAX_X
	elif position.x < MIN_X:
		direction = Vector2(1, 0)
		position.x = MIN_X

	position.y -= 30

func _spawn_trap():
	var spawn_metal_box = false
	if rand_range(clamp(difficulty, 0, 10), 20) > 18:
		spawn_metal_box = true

	var trap
	if spawn_metal_box:
		trap = METAL_BOX_SCN.instance()
	else:
		trap = WOODEN_BOX_SCN.instance()

	trap.set_position(get_position())
	get_parent().add_child(trap)

	$spawn_timer.set_wait_time(randf() * 0.85 + 0.65 - clamp(difficulty / 5, 0, 0.5))
