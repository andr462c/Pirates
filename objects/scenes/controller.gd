extends Node2D

@export var level = 0
@export var level_enemies = [
	[preload("res://objects/enemies/fishing_boat.tscn")],
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = Node2D.new()
	players.name = "Players"
	var player_class = preload("res://objects/playerboat.tscn")
	var player = player_class.instantiate()
	player.global_position = Vector2(300, 200)
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
	for enemy in enemies:
		var instance: Node2D = enemy.instantiate()
		instance.global_position = Vector2(300, 50)
		enemy_node.add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
