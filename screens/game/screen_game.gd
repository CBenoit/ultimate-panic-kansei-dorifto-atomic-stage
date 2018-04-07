extends "../abstract_screen.gd"

var content
var level = preload("res://levels/level_1.tscn")

func _ready():
	content = get_node("content")
	content.add_child(level.instance())
