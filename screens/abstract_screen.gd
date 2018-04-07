# base class for every screen
extends Node

signal next_screen(screen)

func _post_action(action):
	var event = InputEvent()
	event.set_as_action(action, true)
	get_tree().input_event(event)
