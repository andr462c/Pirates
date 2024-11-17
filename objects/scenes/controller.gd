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


var movement_speed = preload("res://objects/modifiers/movement_speed_increase.tscn")
var ak_up = preload("res://objects/modifiers/ak_upgrade.tscn")
var rpg_up = preload("res://objects/modifiers/rpg_upgrade.tscn")
var turret_up = preload("res://objects/modifiers/turret_upgrade.tscn")
var knockback_up = preload("res://objects/modifiers/knockback.tscn")
var bigger_stronger = preload("res://objects/modifiers/bigger_stronger.tscn")
var healthbuf = preload("res://objects/modifiers/healthbuff.tscn")
var jumpboost = preload("res://objects/modifiers/jumpboost.tscn")

var dead_player

@onready var card_selection = get_node("../CardSelectionWater")
@export var healthadder = 0.2
@export var level = -1
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
var players: Node2D

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
	ak_up,
	bigger_stronger,
	rpg_up,
	knockback_up,
	healthbuf,
	jumpboost
]

var text_paths = {
	"AkUpgrade": load("res://assets/cards/ak47.png"),
	"RpgUpgrade": load("res://assets/cards/rpg card.png"),
	"TurretUpgrade": load("res://assets/cards/turret.png"),
	"Healthbuff": load("res://assets/cards/ak47.png"),
	"BiggerStronger": load("res://assets/cards/ak47.png"),
	"JumpBoost": load("res://assets/cards/ak47.png"),
	"Knockback": load("res://assets/cards/ak47.png"),
}

var won = false
var enemy_healthbar
var enemy_healthbar_orig_size
var enemy_healthbar_orig_x

var remember_scene = preload("res://objects/scenes/level_remember.tscn")
var remember

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = Node2D.new()
	players.name = "Players"
	remember = remember_scene.instantiate()
	var player_class = preload("res://objects/playerboat.tscn")
	var offset = Vector2(100, 0)
	for id in Input.get_connected_joypads():
		var player = player_class.instantiate()
		player.name = "P%d" % id;
		player.global_position = Vector2(200, 200) + id * offset
		player.id = id
		var blue_boat = preload("res://assets/boat/rubberboat_blue.png")
		if player.id == 1:
			player.get_node("Sprite2D").texture = blue_boat
		players.add_child(player)
		var health_path = "../Healthbars/P{id}Health".format({"id": id})
		var bar = get_node(health_path) as TextureProgressBar
		print("health_path ", health_path, " ", bar)
		bar.max_value = player.health
		bar.value = player.health
		bar.visible = true
	add_child(players)
	
	var enemies = Node2D.new()
	enemies.name = "Enemies"
	add_child(enemies)
	next_level()
	var camera = preload("res://objects/Camera.tscn")
	add_child(camera.instantiate())
	set_orig_healthbar()
	get_tree().root.call_deferred("add_child", remember)

func next_level():
	revive_players()
	level += 1
	var max_level = remember.max_level
	get_node("/root/Main/MaxLevel/LevelText").text = "[right]Max Level: %d[/right]" % max(max_level, level)
	for player in players.get_children():
		player.health = player.max_health
		player.get_healthbar().max_value = player.max_health
		player.get_healthbar().value = player.health
		print("health ", player.health, " maxhealth ", player.max_health)
		player.immortal = false
	won = false
	construct_enemies()

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
	if enemy_healthbar == null:
		set_orig_healthbar()
	enemy_healthbar.max_value = hp_sum
	enemy_healthbar.value = hp_sum
	var hp_size_scaling = hp_sum/5
	enemy_healthbar.size.x = enemy_healthbar_orig_size + hp_size_scaling
	enemy_healthbar.position.x = enemy_healthbar_orig_x - hp_size_scaling / 2
	
	if has_node("../Music"):
		get_node("../Music").queue_free()
	var new_music = level_music[level % len(level_music)].instantiate()
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
		revive_players()
		for player in players.get_children():
			player.immortal = true
		won = true
		remove_bullets(get_tree().root)
		play_chill_music()
		add_random_cards()
		card_selection.show_cards()

func remove_bullets(node: Node):
	if node.is_in_group("Bullet"):
		node.queue_free()
	else:
		for c in node.get_children():
			remove_bullets(c)

var added_turret = false
func add_random_cards():
	if level > 4 && !added_turret:
		cards.append(turret_up)
		added_turret = true
	cards.shuffle()
	var index = 0
	for child in card_selection.get_children():
		if !child.name.contains("Card"):
			continue
		var card = cards[index].instantiate()
		var desc = card.name
		card.name = "Modifier"
		child.add_child(card)
		(child.get_node("Sprite2D") as Sprite2D).texture = text_paths[desc]
		#(child.get_node("Desc") as RichTextLabel).text = "[center]%s[/center]" % desc
		index += 1

func play_chill_music():
	get_node("../Music").queue_free()
	var new_music = chill_music_scene.instantiate()
	new_music.name = "ChillMusic"
	get_parent().call_deferred("add_child", new_music)
	
func revive_players():
	if dead_player != null:
		players.add_child(dead_player)
		dead_player = null
		
func set_orig_healthbar():
	enemy_healthbar = get_node("../Healthbars/EnemyHealth") as TextureProgressBar
	enemy_healthbar_orig_size = enemy_healthbar.size.x
	enemy_healthbar_orig_x = enemy_healthbar.position.x
