extends Node2D

var fishboat = preload("res://objects/enemies/fishing_boat.tscn")
var naersk = preload("res://objects/enemies/naersk.tscn")
var navy = preload("res://objects/enemies/navy_ship.tscn")

@onready var card_selection = get_node("../CardSelectionWater")
@export var level = 0
@export var healthadder = 0.2
@export var level_enemies = [
	[fishboat],
	[fishboat, fishboat],
	[naersk],
	[naersk, fishboat],
	[navy],
	[fishboat,fishboat,fishboat,fishboat,fishboat],
	[naersk, naersk],
	[navy, fishboat, fishboat],
	[navy, navy]
]

var level_music = [
	preload("res://objects/sounds/complete_overdrive.tscn"),
	preload("res://objects/sounds/complete_overdrive.tscn"),
	preload("res://objects/sounds/complete_overdrive.tscn"),
	preload("res://objects/sounds/complete_overdrive.tscn"),
	preload("res://objects/sounds/complete_overdrive.tscn"),
]

var chill_music_scene = preload("res://objects/sounds/calm_background_music.tscn")

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
	for id in [0]:
		var player = player_class.instantiate()
		player.global_position = Vector2(200, 200) + id * offset
		player.id = id
		players.add_child(player)
		var health_path = "../Healthbars/P{id}Health".format({"id": id})
		var bar = get_node(health_path) as TextureProgressBar
		print("health_path ", health_path, " ", bar)
		bar.max_value = player.health
		bar.value = player.health
	add_child(players)
	
	var enemies = Node2D.new()
	enemies.name = "Enemies"
	add_child(enemies)
	
	construct_enemies()
	
	var camera = preload("res://objects/Camera.tscn")
	add_child(camera.instantiate())

func construct_enemies():
	var enemies = []
	if level < len(level_enemies):
		enemies = level_enemies[level]
	else:
		for i in range(level/2):
			enemies.append(fishboat)
		for i in range(level/6):
			enemies.append(naersk)
		for i in range(level/8):
			enemies.append(naersk)
	var enemy_node = $Enemies
	var offset = Vector2(0, 0)
	var hp_sum = 0
	var counter = 0.0
	for enemy in enemies:
		counter+=1
		var instance: Node2D = enemy.instantiate()
		# add bufs
		instance.health *= 1+healthadder * level
		instance.global_position = Vector2(800, 600*(counter/len(enemies)))
		enemy_node.add_child(instance)
		hp_sum += instance.health
	(get_node("../Healthbars/EnemyHealth") as TextureProgressBar).max_value = hp_sum
	(get_node("../Healthbars/EnemyHealth") as TextureProgressBar).value = hp_sum
	
	if has_node("../Music"):
		get_node("../Music").queue_free()
	var new_music = level_music[level].instantiate()
	new_music.name = "Music"
	get_parent().call_deferred("add_child", new_music)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies_node = $Enemies
	if !won && enemies_node.get_child_count() == 0:
		won = true
		play_chill_music()
		add_random_cards()
		card_selection.show_cards()
		
func add_random_cards():
	for child in card_selection.get_children():
		var card = cards[0].instantiate()
		card.name = "Modifier"
		child.add_child(card)

func play_chill_music():
	get_node("../Music").queue_free()
	var new_music = chill_music_scene.instantiate()
	new_music.name = "Music"
	get_parent().add_child(new_music)
