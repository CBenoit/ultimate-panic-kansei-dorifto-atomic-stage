extends KinematicBody2D

const SPEED_GOAL = 25.0
const MAX_SPEED = 35.0
const MIN_SPEED = 10.0

const ROTATION_SPEED = 0.75
const MIN_ANGLE = -2 * PI / 3
const MAX_ANGLE = -1 * PI / 3

var speed = 10.0
var drift = false
var kansei_dorifto = false

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("drift"):
			if drift == false:
				drift = true
				$anim.play("drift_left")
		else:
			rotate(-ROTATION_SPEED / speed)
	elif Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("drift"):
			if drift == false:
				drift = true
				$anim.play("drift_right")
		else:
			rotate(ROTATION_SPEED / speed)

	if Input.is_action_just_released("drift") and drift:
		drift = false
		rotate($sprite.rotation)
		$anim.stop()
		$sprite.rotation = 0

	set_rotation(clamp(get_rotation(), MIN_ANGLE, MAX_ANGLE))

	if drift:
		speed -= 0.1
	elif speed < SPEED_GOAL:
		speed += 0.1
	elif speed > SPEED_GOAL:
		speed -= 0.1
		
	if Input.is_action_pressed("ui_accept") and kansei_dorifto == false and drift == false:
		kansei_dorifto = true
		speed += MAX_SPEED - SPEED_GOAL
		$anim.play("kansei_dorifto")
	
	speed = clamp(speed, MIN_SPEED, MAX_SPEED)

	var movement = Vector2(cos(rotation), sin(rotation)) * speed
	move_and_collide(movement)
