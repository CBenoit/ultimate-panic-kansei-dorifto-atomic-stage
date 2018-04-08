extends KinematicBody2D

# other scenes
const smoke_scn = preload("res://effects/smoke.tscn")
const track_scn = preload("res://effects/track.tscn")
const sparcle_scn = preload("res://effects/sparcle.tscn")
const explosion = preload("res://effects/explosion_effect.tscn")

# constants
const SPEED_GOAL = 25.0
const SPEED_GOAL_EPSILON = 0.15
const MAX_SPEED = 40.0
const MIN_SPEED = 10.0

const MALUS_SPEED = 20
const ROTATION_SPEED = 0.8
const MIN_ANGLE = -PI / 2 - 0.7
const MAX_ANGLE = -PI / 2 + 0.7

const MAX_X = 540
const MIN_X = -540

var KANSEIDORIFTO = true

var normal_state_func = funcref(self, "_normal_state")
var drift_state_func = funcref(self, "_drift_state")
var kansei_drift_state_func = funcref(self, "_kansei_drift_state")

# properties
var speed = 10.0
var state = normal_state_func
var dead = false

func _physics_process(delta):
	if dead:
		return
	
	state.call_func()
	
	if position.x > MAX_X:
		position.x = MAX_X
		set_rotation(-PI / 2)
	elif position.x < MIN_X:
		position.x = MIN_X
		set_rotation(-PI / 2)

	set_rotation(clamp(get_rotation(), MIN_ANGLE, MAX_ANGLE))
	speed = clamp(speed, MIN_SPEED, MAX_SPEED)

	var movement = Vector2(cos(rotation), sin(rotation)) * speed
	var info = move_and_collide(movement)
	if info != null:
		var invincible = state == kansei_drift_state_func or speed > SPEED_GOAL + SPEED_GOAL_EPSILON
		if "lethal" in info.collider.get_groups() and !invincible:
			destroy()
		elif "destructible" in info.collider.get_groups():
			info.collider.destroy()
			if !invincible:
				speed -= MALUS_SPEED

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

	if Input.is_action_pressed("kansei_drift") and KANSEIDORIFTO:
		KANSEIDORIFTO = false
		state = kansei_drift_state_func
		speed += MAX_SPEED - SPEED_GOAL
		$anim.play("kansei_dorifto")
		$anim.connect("animation_finished", self, "_kansei_drift_finished")

	if speed < SPEED_GOAL - SPEED_GOAL_EPSILON:
		speed += 0.1
	elif speed > SPEED_GOAL + SPEED_GOAL_EPSILON:
		speed -= 0.1
		_drift_at($sprite/wheel_back_left)
		_drift_at($sprite/wheel_back_right)

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
	_drift_at($sprite/wheel_back_left)
	_drift_at($sprite/wheel_back_right)
	_drift_at($sprite/wheel_front_left)
	_drift_at($sprite/wheel_front_right)

func _kansei_drift_finished(dummy):
	$doriftocooldown.start()
	state = normal_state_func
	$anim.disconnect("animation_finished", self, "_kansei_drift_finished")

func _drift_at(wheel_pos):
	var smoke = smoke_scn.instance()
	smoke.set_position(wheel_pos.to_global(Vector2(0, 0)))
	get_parent().get_parent().get_node("layer_2").add_child(smoke)
	smoke.activate()

	var track = track_scn.instance()
	track.set_position(wheel_pos.to_global(Vector2(0, 0)))
	track.set_rotation(get_rotation())
	get_parent().get_parent().get_node("layer_1").add_child(track)
	track.activate()
	
	var sparcle = sparcle_scn.instance()
	sparcle.set_position(wheel_pos.to_global(Vector2(0, 0)))
	sparcle.set_rotation(get_rotation())
	get_parent().get_parent().get_node("layer_1").add_child(sparcle)
	sparcle.activate()
	 

func _on_doriftocooldown_timeout():
	$doriftocooldown.stop()
	KANSEIDORIFTO = true

func destroy():
	if not dead:
		var inst = explosion.instance()
		inst.set_position(get_position())
		inst.set_rotation(get_rotation() + (PI / 2))
		get_parent().add_child(inst)
		inst.set_texture($sprite.get_texture())
		inst.activate()
		$sprite.queue_free()
		dead = true
