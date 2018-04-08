extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var thimotee_le_timer
var fonseca_la_kuruma

func _ready():
	thimotee_le_timer = get_parent().get_parent().get_node("doriftocooldown")
	fonseca_la_kuruma = get_parent().get_parent()
	pass

func _process(delta):
	$toto.set_value(((thimotee_le_timer.wait_time - thimotee_le_timer.time_left)/thimotee_le_timer.wait_time)*100)
	$labelle.set_text(str(int(fonseca_la_kuruma.to_global(Vector2(0, 0)).y*-1)))
	pass