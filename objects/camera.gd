extends Camera2D

@onready var players: Node2D = get_node("../Players")
@onready var enemies: Node2D = get_node("../Enemies")
var background: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = Utils.find_child(get_tree().root, "Background")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nodes: Array[Node2D] = []
	for p in players.get_children():
		nodes.append(p)
	for e in enemies.get_children():
		nodes.append(e)
	var bb = Utils.bounding_box(nodes)
	# TODO Get these numbers programatically!!
	var width = 1200
	var height = 800
	var screen_width = 600
	var screen_height = 400
	
	var zoomfactor = 1
	var bbwidth = bb[1].x - bb[0].x
	var bbheight= bb[1].y - bb[0].y
	var buffer = 1.3
	zoomfactor = max(zoomfactor, bbwidth / screen_width * buffer)
	zoomfactor = max(zoomfactor, bbheight / screen_height * buffer)
	zoomfactor = min(zoomfactor, 2)
	zoom = Vector2(1/zoomfactor, 1/zoomfactor)
	
	var allowed_top_left = Vector2(zoomfactor * screen_width / 2, zoomfactor * screen_height /2)
	var allowed_bottom_right = Vector2(width - allowed_top_left.x, height - allowed_top_left.y)
	var middle = Vector2((bb[0].x + bb[1].x) / 2, (bb[0].y + bb[1].y)/2)
	middle.x = clamp(middle.x, allowed_top_left.x, allowed_bottom_right.x)
	middle.y = clamp(middle.y, allowed_top_left.y , allowed_bottom_right.y)
	global_position = middle
