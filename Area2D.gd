extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func add_body():
	self.get_parent().get_parent().get_parent().add_body()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
