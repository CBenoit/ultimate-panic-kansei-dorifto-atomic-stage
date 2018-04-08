extends "./abstract_effect.gd"

func _on_activate():
	$particles.set_emitting(true)

func set_texture(texture):
	$particles.set_texture(texture)
