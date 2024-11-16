extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var explotion = preload("res://objects/bullets/explosion.tscn").instantiate()
	explotion.global_position = global_position
	explotion.scale *= 2
	get_tree().root.add_child(explotion)
	get_parent().queue_free()
	
