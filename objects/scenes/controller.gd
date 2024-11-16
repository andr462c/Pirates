extends Node2D

@onready var card_selection = get_node("../CardSelectionWater")
@export var level = 0
@export var level_enemies = [
	[preload("res://objects/enemies/naersk.tscn")],
	[preload("res://objects/enemies/fishing_boat.tscn")],
	[preload("res://objects/enemies/navy_ship.tscn")],
	[preload("res://objects/enemies/fishing_boat.tscn"), preload("res://objects/enemies/fishing_boat.tscn")],
]

var cards = [
	preload("res://objects/modifiers/movement_speed_increase.tscn")
]

var won = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = Node2D.new()
	players.name = "Players"
	var player_class = preload("res://objects/playerboat.tscn")
	var offset = Vector2(100, 0)
	for id in Input.get_connected_joypads():
		var player = player_class.instantiate()
		player.global_position = Vector2(300, 200) + id * offset
		player.id = id
		players.add_child(player)
	add_child(players)
	
	var enemies = Node2D.new()
	enemies.name = "Enemies"
	add_child(enemies)
	
	construct_enemies()
	
	var camera = preload("res://objects/Camera.tscn")
	add_child(camera.instantiate())

func construct_enemies():
	var enemies = level_enemies[level]
	var enemy_node = $Enemies
	var offset = Vector2(0, 0)
	var hp_sum = 0
	for enemy in enemies:
		var instance: Node2D = enemy.instantiate()
		instance.global_position = Vector2(300, 50)
		enemy_node.add_child(instance)
		hp_sum += instance.health
	(get_node("../Healthbars/EnemyHealth") as TextureProgressBar).max_value = hp_sum
	(get_node("../Healthbars/EnemyHealth") as TextureProgressBar).value = hp_sum

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies_node = $Enemies
	if !won && enemies_node.get_child_count() == 0:
		won = true
		add_random_cards()
		card_selection.show_cards()
		
func add_random_cards():
	for child in card_selection.get_children():
		var card = cards[0].instantiate()
		card.name = "Modifier"
		child.add_child(card)
