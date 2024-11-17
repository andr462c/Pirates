extends Node2D

var item_index = -1

@onready
var power_up_sound = $PowerUpSound
@onready
var switch_sound = $UiSwitchSound
@onready
var outline = $Card1/Outline

var p1_modifier
var p2_modifier

var p1
var p2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func show_cards():
	visible = true
	$Card1/Area2D.monitoring = true
	$Card2/Area2D.monitoring = true
	$Card3/Area2D.monitoring = true
	selected[0] = false
	selected[1] = false
	p1 = get_node("/root/Main/Controller/Players/P0")
	if has_node("/root/Main/Controller/Players/P1"):
		p2 = get_node("/root/Main/Controller/Players/P1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_select_0"):
		confirm_selection(p1_modifier, 0)
	elif Input.is_action_just_pressed("key_select_1"):
		confirm_selection(p2_modifier, 1)


func _card1_entered(body: Node2D) -> void:
	if item_index != 0:
		switch_sound.play()
	item_index = 0
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	if body.id == 0:
		p1_modifier = get_child(item_index).get_node("Modifier")
		p2_modifier = null
	else:
		p2_modifier = get_child(item_index).get_node("Modifier")
		p1_modifier = null
	

func _card2_entered(body: Node2D) -> void:
	if item_index != 1:
		switch_sound.play()
	item_index = 1
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	if body.id == 0:
		p1_modifier = get_child(item_index).get_node("Modifier")
		p2_modifier = null
	else:
		p2_modifier = get_child(item_index).get_node("Modifier")
		p1_modifier = null


func _card3_entered(body: Node2D) -> void:
	if item_index != 2:
		switch_sound.play()
	item_index = 2
	$Card1/Outline.visible = false
	$Card2/Outline.visible = false
	$Card3/Outline.visible = false
	if body.id == 0:
		p1_modifier = get_child(item_index).get_node("Modifier")
		p2_modifier = null
	else:
		p2_modifier = get_child(item_index).get_node("Modifier")
		p1_modifier = null


func _card_left(bodt: Node2D) -> void:
	pass

var selected = [false, false]

func confirm_selection(modifier: Node2D, p_id: int):
	if item_index == -1 || visible == false || modifier == null:
		return
	
	if selected[p_id]:
		return
	
	selected[p_id] = true
	
	print("Selected: ", item_index)
	power_up_sound.play()
	get_child(item_index).visible = false
	get_node("Card%d/Area2D" % (item_index + 1)).monitoring = false
	
	if p_id == 0:
		modifier.modify_player(p1)
	else:
		modifier.modify_player(p2)
	
	if !selected[1 - p_id] && p1 != null && p2 != null:
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
	
