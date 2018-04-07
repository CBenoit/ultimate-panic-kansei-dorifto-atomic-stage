extends KinematicBody2D

# other scenes
const smoke_scn = preload("res://effects/smoke.tscn")
const track_scn = preload("res://effects/track.tscn")

# constants
const SPEED_GOAL = 25.0
const MAX_SPEED = 45.0
const MIN_SPEED = 10.0

const ROTATION_SPEED = 0.75
const MIN_ANGLE = -2 * PI / 3
const MAX_ANGLE = -1 * PI / 3

const MAX_X = 540
const MIN_X = -540

var normal_state_func = funcref(self, "_normal_state")
var drift_state_func = funcref(self, "_drift_state")
var kansei_drift_state_func = funcref(self, "_kansei_drift_state")

# properties
var speed = 10.0
var state = normal_state_func

func _physics_process(delta):
	state.call_func()
	
	if position.x > MAX_X:
		position.x = MAX_X
		set_rotation(Vector2(cos(rotation), sin(rotation)).reflect(Vector2(0, 1)).angle())
	elif position.x < MIN_X:
		position.x = MIN_X
		set_rotation(Vector2(cos(rotation), sin(rotation)).reflect(Vector2(0, 1)).angle())

	set_rotation(clamp(get_rotation(), MIN_ANGLE, MAX_ANGLE))
	speed = clamp(speed, MIN_SPEED, MAX_SPEED)

	var movement = Vector2(cos(rotation), sin(rotation)) * speed
	var info = move_and_collide(movement)
	if info != null and "destructible" in info.collider.get_groups():
		info.collider.destroy()
		if state != kansei_drift_state_func:
			speed -= 20

func _normal_state():
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("drift"):
			state = drift_state_func
			$anim.play("drift_left")
		else:
			rotate(-ROTATION_SPEED / speed)
	elif Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("drift"):
			state = drift_state_func
			$anim.play("drift_right")
		else:
			rotate(ROTATION_SPEED / speed)

	if Input.is_action_pressed("ui_accept"):
		state = kansei_drift_state_func
		speed += MAX_SPEED - SPEED_GOAL
		$anim.play("kansei_dorifto")
		$anim.connect("animation_finished", self, "_kansei_drift_finished")

	if speed < SPEED_GOAL:
		speed += 0.1
	elif speed > SPEED_GOAL:
		speed -= 0.1

func _drift_state():
	_drift_at($sprite/wheel_back_left)
	_drift_at($sprite/wheel_back_right)
	
	speed -= 0.1
	if Input.is_action_just_released("drift"):
		state = normal_state_func
		rotate($sprite.rotation)
		$anim.stop()
		$sprite.rotation = 0

func _kansei_drift_state():
	pass

func _kansei_drift_finished(dummy):
	state = normal_state_func
	$anim.disconnect("animation_finished", self, "_kansei_drift_finished")

func _drift_at(wheel_pos):
	#var smoke = smoke_scn.instance()
	#smoke.set_position(wheel_pos.to_global(wheel_pos.get_position()))
	#get_node("../..").add_child(smoke)
	#smoke.activate()

	var track = track_scn.instance()
	track.set_position(wheel_pos.to_global(wheel_pos.get_position()))
	get_node("../..").add_child(track)
	track.activate()
