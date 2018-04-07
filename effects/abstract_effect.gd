extends Node2D

func _ready():
	$expire_timeout.connect("timeout", self, "queue_free")

# activate should be called once the effect has been added to the graph
# otherwise, curious problems may occur (such as sounds not being played
# as the sound node is not yet added to the graph too).
func activate():
	_on_activate()
