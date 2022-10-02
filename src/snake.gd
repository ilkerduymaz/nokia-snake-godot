extends Control

signal restart

var body = preload("res://scene/Body2.tscn")
var prey = preload("res://scene/Prey.tscn")

var x = 0
onready var pos = [Vector2(6, 9), Vector2(2, 9)]
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

var px = 0
var py = 0

var new_pos = Vector2(0,0)
var last_pos = Vector2(0,0)
var last_rot = 0

var turned = false
var can_turn = true

var score = 0

onready var rect = $Panel.get_rect()
onready var maxrect = rect.size
onready var minrect = rect.position

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOver.hide()
	$Panel/Prey.set_position(Vector2(56, 24))
	for child_n in $Panel/Snake.get_child_count():
		$Panel/Snake.get_children()[child_n].set_position(pos[child_n]) 
	
	
func set_pos():
	get_xy()
	new_pos = pos[0] + Vector2(mx, my)
	
	if new_pos[0] >= maxrect[0]-4:
		new_pos[0] = minrect[0]
	if new_pos[1] >= maxrect[1]:
		new_pos[1] = minrect[1]	
	
	if new_pos[0] < minrect[0]:
		new_pos[0] = maxrect[0]
	if new_pos[1] < minrect[1]:
		new_pos[1] = maxrect[1]	
		
	pos.insert(0, new_pos)
	last_pos = pos.pop_back()

	for child_n in $Panel/Snake.get_child_count():
		$Panel/Snake.get_children()[child_n].set_position(pos[child_n]) 
func calc_new_pos():
	new_pos = pos[0] + Vector2(mx, my)
	
	if direction == "RIGHT":
		if new_pos[0] >= maxrect[0]-2:
			new_pos[0] = minrect[0]+2
	elif  direction == "DOWN":
		if new_pos[1] >= maxrect[1]+2:
			new_pos[1] = minrect[1]+3	
	elif direction == "LEFT":
		if new_pos[0] < minrect[0]:
			new_pos[0] = maxrect[0]-2
	elif direction == "UP":
		if new_pos[1] < minrect[1]+2:
			new_pos[1] = maxrect[1]+4	
		
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
	
	
	for child_n in $Panel/Snake.get_child_count():
		$Panel/Snake.get_children()[child_n].set_position(pos[child_n]) 
		$Panel/Snake.get_children()[child_n].set_rotation_degrees(rot[child_n])

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
	
	
	for child_n in $Panel/Snake.get_child_count():
		$Panel/Snake.get_children()[child_n].set_rotation_degrees(rot[child_n])
		
func add_body():
	pos.append(last_pos)
	rot.append(last_rot)
	$Panel/Snake.add_child(body.instance())

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
		
	if Input.is_action_just_released("ui_accept"):
		emit_signal("restart")
		
func _on_Prey_prey_eaten():
	score += 5
	var stext = "%d" %[score]
	for i in max(0, 4 - len(stext)):
		stext = "".join(["0", stext])
	$Score.text = stext
	add_body()
	randomize()
	px = rand_range(minrect[0]+2, maxrect[0]-2)
	py = rand_range(minrect[1]+2, maxrect[1]-2)
	$Panel/Prey.set_position(Vector2(int(px), int(py)))

func die():
	$GameOver/VBoxContainer/Label2.text = "Score: %d" % [score]
	$GameOver.show()
	$Timer.stop()
	yield(self, "restart")
	get_tree().reload_current_scene()

func _on_Timer_timeout():
	$Timer.start()
	set_posrot()
	
func _on_Body_body_collision():
	pass
