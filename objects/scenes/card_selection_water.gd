extends Node2D

var item_index = -1

@onready
var power_up_sound = $PowerUpSound
@onready
var switch_sound = $UiSwitchSound
@onready
var outline = $Card1/Outline

var player1
var player2

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
	if Input.is_action_just_pressed("key_select_0"):
		if player1 == null:
			player1 = get_node("/root/Main/Controller/Players/P0")
		confirm_selection(player1)
	elif Input.is_action_just_pressed("key_select_1"):
		if player2 == null:
			player2 = get_node("/root/Main/Controller/Players/P1")
		confirm_selection(player2)


func _card1_entered(body: Node2D) -> void:
	if item_index != 0:
		switch_sound.play()
	item_index = 0
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	if body.id == 0:
		player1 = body
	else:
		player2 = body
	

func _card2_entered(body: Node2D) -> void:
	if item_index != 1:
		switch_sound.play()
	item_index = 1
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	if body.id == 0:
		player1 = body
	else:
		player2 = body


func _card3_entered(body: Node2D) -> void:
	if item_index != 2:
		switch_sound.play()
	item_index = 2
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	if body.id == 0:
		player1 = body
	else:
		player2 = body


func _card_left(bodt: Node2D) -> void:
	pass

var selected = 0
var player_who_selected

func confirm_selection(player: PlayerBoat):
	if item_index == -1 || visible == false:
		return
	
	if selected == 1 && player_who_selected == player:
		return
	
	selected += 1
	
	print("Selected: ", item_index)
	power_up_sound.play()
	get_child(item_index).visible = false
	get_node("Card%d/Area2D" % (item_index + 1)).monitoring = false
	
	get_child(item_index).get_node("Modifier").modify_player(player)
	player_who_selected = player
	
	if selected < 2:
		return
		
	for child in get_children():
		if !child.name.contains("Card"):
			continue
		child.visible = true
		child.get_node("Modifier").queue_free()
	visible = false
	$Card1/Area2D.monitoring = false
	$Card2/Area2D.monitoring = false
	$Card3/Area2D.monitoring = false
	
	var controller = get_node("../Controller")
	if has_node("../ChillMusic"):
		get_node("../ChillMusic").queue_free()
	controller.next_level()
	selected = 0
	player_who_selected = null
	
