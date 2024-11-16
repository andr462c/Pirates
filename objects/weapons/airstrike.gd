extends Area2D

var plane_scene = preload("res://objects/weapons/plane.tscn")

@onready
var timer = $Timer
@onready
var marker = $Marker

var player_boat

@onready
var total_time = timer.wait_time

var dropped_bomb = false

var plane

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_boat = get_node("/root/Main/Playerboat");
	var player_position = player_boat.position
	var noise = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	marker.position = player_position + noise


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if marker != null:
		var factor = (total_time - timer.time_left) / total_time
		marker.scale = Vector2(factor, factor)

func _on_timer_timeout() -> void:
	plane = plane_scene.instantiate()
	plane.init(marker)
	add_child(plane)
