extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal prey_eaten

var x = 0
var y = 0

onready var wx = get_viewport().size.x/10
onready var hx = get_viewport().size.y/10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):	
	randomize()
	x = rand_range(0, wx-3)
	y = rand_range(0, hx-3)
	self.set_position(Vector2(int(x), int(y)))
	emit_signal("prey_eaten")
