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
var players: Array[Node] = []
var plane

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = Utils.find_child(get_tree().root, "Players").get_children()
	if len(players) == 0:
		return
	var idx = randi_range(0, len(players)-1)
	var player = players[idx]
	var player_position = player.global_position
	var spread = 100.
	var noise = Vector2(randf_range(-spread, spread), randf_range(-spread, spread))
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
