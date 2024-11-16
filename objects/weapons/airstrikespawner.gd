extends Timer

@onready
var airstrike_scene = preload("res://objects/weapons/airstrike.tscn")

func _on_timeout() -> void:
	var airstrike = airstrike_scene.instantiate()
	get_tree().root.add_child(airstrike)
