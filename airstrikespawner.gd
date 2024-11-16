extends Node2D

var airstrike_scene = preload("res://objects/weapons/airstrike.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var airstrike = airstrike_scene.instantiate()
	get_tree().root.add_child(airstrike)
