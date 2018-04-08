extends Control

func _process(delta):
	var thimotee_le_timer = get_parent().get_parent().get_node("content/level/layer_3/kuruma/doriftocooldown")
	var fonseca_la_kuruma = get_parent().get_parent().get_node("content/level/layer_3/kuruma")
	if thimotee_le_timer != null and fonseca_la_kuruma != null:
		$toto.set_value(((thimotee_le_timer.wait_time - thimotee_le_timer.time_left)/thimotee_le_timer.wait_time)*100)
		$labelle.set_text(str(int(fonseca_la_kuruma.to_global(Vector2(0, 0)).y*-1)))