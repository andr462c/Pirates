extends Node2D

var fishboat = preload("res://objects/enemies/fishing_boat.tscn")
var naersk = preload("res://objects/enemies/naersk.tscn")
var navy = preload("res://objects/enemies/navy_ship.tscn")

var sea_shanty_8 = preload("res://objects/sounds/sea_shanty_8_bit.tscn")
var drum_delux_fast = preload("res://objects/sounds/drum_deluxe_fast.tscn")
var shaky_chiptune = preload("res://objects/sounds/shaky_chip_tune.tscn")
var bit_crushed = preload("res://objects/sounds/bit_crushed_nightcore.tscn")
var hes_a_somali_pirate = preload("res://objects/sounds/hes_a_somali_pirate.tscn")
var aggresive_drums = preload("res://objects/sounds/aggressive_drums.tscn")
var complete_overdrive = preload("res://objects/sounds/complete_overdrive.tscn")

@onready var card_selection = get_node("../CardSelectionWater")
@export var level = 0
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
	sea_shanty_8,
	sea_shanty_8,
	drum_delux_fast,
	drum_delux_fast,
	complete_overdrive,
	shaky_chiptune,
	aggresive_drums,
	hes_a_somali_pirate,
	bit_crushed,
]

var level_names = [
	"Cannon Fodder",
	"Sunny Seas",
	"Tunisian Trouble",
	"Evergreen in the Suez",
	"Dire DARPA",
	"Greeting from Novo",
	"Treasures Up Ahead",
	"X marks the spot",
	"Almost there!",
	"Bullet Heaven",
]

var chill_music_scene = preload("res://objects/sounds/calm_background_music.tscn")

var cards = [
	preload("res://objects/modifiers/movement_speed_increase.tscn"),
	preload("res://objects/modifiers/ak_upgrade.tscn"),
	preload("res://objects/modifiers/rpg_upgrade.tscn"),
	preload("res://objects/modifiers/turret_upgrade.tscn"),
	preload("res://objects/modifiers/knockback.tscn")
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
		player.global_position = Vector2(200, 200) + id * offset
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
	
	var level_name = ""
	if level >= level_names.size():
		level_name = "Bullet Heaven"
		for i in level - 9:
			level_name + "+"
	else:
		level_name = level_names[level]
	
	(get_node("../LevelName/LevelText") as RichTextLabel).text = "Level %d: %s" % [level + 1, level_name]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies_node = $Enemies
	if !won && enemies_node.get_child_count() == 0:
		won = true
		play_chill_music()
		add_random_cards()
		card_selection.show_cards()
		
func add_random_cards():
	cards.shuffle()
	var index = 0
	for child in card_selection.get_children():
		if !child.name.contains("Card"):
			continue
		var card = cards[index].instantiate()
		var desc = card.name
		card.name = "Modifier"
		child.add_child(card)
		(child.get_node("Desc") as RichTextLabel).text = "[center]%s[/center]" % desc
		index += 1

func play_chill_music():
	get_node("../Music").queue_free()
	var new_music = chill_music_scene.instantiate()
	new_music.name = "ChillMusic"
	get_parent().call_deferred("add_child", new_music)
