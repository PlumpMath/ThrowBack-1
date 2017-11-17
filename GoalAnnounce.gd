extends Node2D

var active = false
var activeTime = 3
var timer = 0
var screenHeight

func _ready():
	hide()
	screenHeight = get_viewport_rect().size.y / 2
	set_process(true)

func _process(delta):
	if active:
		var playerLocation = get_parent().get_pos().y
		if playerLocation >= screenHeight:
			set_pos(Vector2(0,-125))
		else:
			set_pos(Vector2(0,125))
		timer += delta
		if timer > activeTime:
			active = false
			get_parent().goalActionsEnd()
		
func showMe():
	timer = 0
	show()
	active = true