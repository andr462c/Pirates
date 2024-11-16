extends Control

@onready
var power_up_sound = $PowerUpSound
@onready
var switch_sound = $UiSwitchSound
var first_focus = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

func show_overlay():
	self.visible = true
	get_node("CardContainer/Card1").grab_focus()
	
func hide_overlay():
	self.visible = false


func _on_card_1_pressed() -> void:
	handle_selection(0)


func _on_card_2_pressed() -> void:
	handle_selection(1)


func _on_card_3_pressed() -> void:
	handle_selection(2)
	
func handle_selection(index: int) -> void:
	power_up_sound.play()


func _on_card_focus_entered() -> void:
	if first_focus:
		first_focus = false
		return
		
	switch_sound.stop()
	switch_sound.play()
