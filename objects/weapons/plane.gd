extends Sprite2D

var explosion_scene = preload("res://objects/bullets/explosion.tscn")

@export
var speed = 400
var move_delta

var target
var marker
var bomb_dropped = false

var bomb_sound = preload("res://objects/sounds/bomb_sound.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += move_delta * speed * delta
	if !bomb_dropped:
		if move_delta.x > 0 && position.x > target.x:
			drop_bomb()
		elif move_delta.x < 0 && position.x < target.x:
			drop_bomb()
		elif move_delta.y > 0 && position.y > target.y:
			drop_bomb()
		elif move_delta.y < 0 && position.y < target.y:
			drop_bomb()
	
	
func drop_bomb():
	bomb_dropped = true
	var explosion = explosion_scene.instantiate()
	explosion.position = target
	explosion.scale *= 2
	explosion.add_child(bomb_sound.instantiate())
	get_tree().root.call_deferred("add_child", explosion)
	marker.queue_free()

func _on_timer_timeout() -> void:
	queue_free()
	
func init(marker: Node2D):
	self.marker = marker
	self.target = marker.position
	var rand = randi_range(1, 4)
	if rand == 1:
		position = Vector2(1000, target.y)
		rotate(-PI/2)
		move_delta = Vector2(-1, 0)
	elif rand == 2:
		position = Vector2(-1000, target.y)
		rotate(PI/2)
		move_delta = Vector2(1, 0)
	elif rand == 3:
		position = Vector2(target.x, 1000)
		move_delta = Vector2(0, -1)
	else:
		position = Vector2(target.x, -1000)
		rotate(PI)
		move_delta = Vector2(0, 1)
