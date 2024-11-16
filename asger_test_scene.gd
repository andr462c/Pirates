extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_node("Playerboat2").id = 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	get_node("CardSelection").show_overlay()
