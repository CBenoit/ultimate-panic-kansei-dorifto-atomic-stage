extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var thimotee_le_timer

func _ready():
	thimotee_le_timer = get_parent().get_parent().get_node("doriftocooldown")
	pass

func _process(delta):
	$toto.set_value(((thimotee_le_timer.wait_time - thimotee_le_timer.time_left)/thimotee_le_timer.wait_time)*100)
	pass