extends Control

var body = preload("res://Body2.tscn")
var prey = preload("res://Prey.tscn")

var x = 0
onready var pos = [Vector2(42, 24), Vector2(38, 24)]
onready var rot = [0, 0]

var direction = "RIGHT"
var speed = 4

var mx = speed
var my = 0
var mrot = 0
var prev_mrot = 0

var ax = 0
var ay = 0

var wx = 84
var hx = 48

var new_pos = Vector2(0,0)
var last_pos = Vector2(0,0)
var last_rot = 0

var turned = false
var can_turn = true


# Called when the node enters the scene tree for the first time.
func _ready():

	$Prey.set_position(Vector2(56, 24))
	for child_n in $Snake.get_child_count():
		$Snake.get_children()[child_n].set_position(pos[child_n]) 
	
	
func set_pos():
	get_xy()
	new_pos = pos[0] + Vector2(mx, my)
	
	if new_pos[0] >= wx:
		new_pos[0] = 0
	if new_pos[1] >= hx:
		new_pos[1] = 0	
	
	if new_pos[0] < 0:
		new_pos[0] = wx
	if new_pos[1] < 0:
		new_pos[1] = hx	
		
	pos.insert(0, new_pos)
	last_pos = pos.pop_back()

	for child_n in $Snake.get_child_count():
		$Snake.get_children()[child_n].set_position(pos[child_n]) 
func calc_new_pos():
	new_pos = pos[0] + Vector2(mx, my)
	
	if new_pos[0] >= wx:
		new_pos[0] = 0
	if new_pos[1] >= hx:
		new_pos[1] = 1	
	
	if new_pos[0] < 0:
		new_pos[0] = wx
	if new_pos[1] < 0:
		new_pos[1] = hx-1	
		
func set_posrot():
	get_xy()
	
	if prev_mrot != mrot and can_turn:
		rot[0] = mrot
		can_turn = false
	elif not can_turn:
		can_turn = true
		rot.insert(0, prev_mrot)
		last_rot = rot.pop_back()
	else:
		rot.insert(0, mrot)
		last_rot = rot.pop_back()
	
	if prev_mrot == mrot:
		calc_new_pos()
		pos.insert(0, new_pos)
		last_pos = pos.pop_back()
	
	
	for child_n in $Snake.get_child_count():
		$Snake.get_children()[child_n].set_position(pos[child_n]) 
		$Snake.get_children()[child_n].set_rotation_degrees(rot[child_n])

func get_xy():
	prev_mrot = mrot	
	if direction == "RIGHT":
		mx = speed
		my = 0
		mrot = 0

	elif direction == "UP":
		my = -speed
		mx = 0		
		mrot = -90

	if direction == "LEFT":
		mx = -speed
		my = 0
		mrot = -180

	elif direction == "DOWN":
		my = speed
		mx = 0
		mrot = 90
		
func set_rot():
	rot[0] = mrot
	rot.insert(0, mrot)
	last_rot = rot.pop_back()
	
	
	for child_n in $Snake.get_child_count():
		$Snake.get_children()[child_n].set_rotation_degrees(rot[child_n])
		
func add_body():
	pos.append(last_pos)
	rot.append(last_rot)
	$Snake.add_child(body.instance())

func _process(delta):
#	x += 10
#	pos = Vector2(x, 0)
#	$Snake.set_position(pos)
#	$Snake.position.x = min(x, 84)
	pass

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if Input.is_action_just_released("ui_up") and direction != "DOWN" and can_turn:
		direction = "UP"
	elif Input.is_action_just_released("ui_down") and direction != "UP" and can_turn:
		direction = "DOWN"
	elif Input.is_action_just_released("ui_left") and direction != "RIGHT" and can_turn:
		direction = "LEFT"
	elif Input.is_action_just_released("ui_right") and direction != "LEFT" and can_turn:
		direction = "RIGHT"
		
func _on_Prey_prey_eaten():
	add_body()

func die():
	get_tree().quit()

func _on_Timer_timeout():
	$Timer.start()
	set_posrot()
	
func _on_Body_body_collision():
	pass
