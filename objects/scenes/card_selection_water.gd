extends Node2D

var item_index = -1
var items = []

@onready
var power_up_sound = $PowerUpSound
@onready
var switch_sound = $UiSwitchSound
@onready
var outline = $Card1/Outline

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func show_cards():
	visible = true
	$Card1/Area2D.monitoring = true
	$Card2/Area2D.monitoring = true
	$Card3/Area2D.monitoring = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		confirm_selection()


func _card1_entered(body: Node2D) -> void:
	if item_index != 0:
		switch_sound.play()
	item_index = 0
	$Card1/Outline.visible = true
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	

func _card2_entered(body: Node2D) -> void:
	if item_index != 1:
		switch_sound.play()
	item_index = 1
	$Card1/Outline.visible = false
	$Card2/Outline.visible = true
	$Card3/Outline.visible = false


func _card3_entered(body: Node2D) -> void:
	if item_index != 2:
		switch_sound.play()
	item_index = 2
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = true


func _card_left(bodt: Node2D) -> void:
	pass


func confirm_selection():
	if item_index == -1:
		return
	
	print("Selected: ", item_index)
	power_up_sound.play()
	visible = false
	$Card1/Area2D.monitoring = false
	$Card2/Area2D.monitoring = false
	$Card3/Area2D.monitoring = false
	
	var controller = get_node("../Controller")
	controller.level += 1
	controller.construct_enemies()
	