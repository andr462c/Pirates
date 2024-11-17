extends Node2D

var item_index = -1

@onready
var power_up_sound = $PowerUpSound
@onready
var switch_sound = $UiSwitchSound
@onready
var outline = $Card1/Outline

var player

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
	player = body
	

func _card2_entered(body: Node2D) -> void:
	if item_index != 1:
		switch_sound.play()
	item_index = 1
	$Card1/Outline.visible = false
	$Card2/Outline.visible = true
	$Card3/Outline.visible = false
	player = body


func _card3_entered(body: Node2D) -> void:
	if item_index != 2:
		switch_sound.play()
	item_index = 2
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = true
	player = body


func _card_left(bodt: Node2D) -> void:
	pass


func confirm_selection():
	if item_index == -1 || visible == false:
		return
	
	print("Selected: ", item_index)
	power_up_sound.play()
	visible = false
	$Card1/Area2D.monitoring = false
	$Card2/Area2D.monitoring = false
	$Card3/Area2D.monitoring = false
	
	get_child(item_index).get_node("Modifier").modify_player(player)
	for child in get_children():
		if !child.name.contains("Card"):
			continue
		child.get_node("Modifier").queue_free()
	
	var controller = get_node("../Controller")
	if has_node("../ChillMusic"):
		get_node("../ChillMusic").queue_free()
	controller.next_level()
	
