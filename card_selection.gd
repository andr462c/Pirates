extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true

func show_overlay():
	self.visible = true
	
func hide_overlay():
	self.visible = false


func _on_card_1_pressed() -> void:
	print("LOL")


func _on_card_2_pressed() -> void:
	print("OMEGA")
