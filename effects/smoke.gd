extends "./abstract_effect.gd"

func _on_activate():
	$quick.set_emitting(true)
	$remaining.set_emitting(true)
