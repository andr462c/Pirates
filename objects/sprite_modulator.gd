extends Node2D

@export var time = 0.5
@export var color = Color(0.75, 0, 0, 0.75)
var cur_direction = false
var cur_color = Color(1, 1, 1)
var cur_time = 0
var sprite: Sprite2D

func modulate(_sprite: Sprite2D):
	cur_direction = true
	sprite = _sprite

func _process(delta: float) -> void:
	if not cur_direction and cur_time == 0:
		return
		
	if cur_direction:
		cur_time += delta
	else:
		cur_time -= delta
	cur_time = clamp(cur_time, 0, time)
	
	var fraction = cur_time / time
	var start_color = Color(1,1,1)
	var end_color = color
	cur_color = start_color * (1 - fraction) + fraction * end_color
	sprite.modulate = cur_color
	
	if cur_time == time and cur_direction:
		cur_direction = false
