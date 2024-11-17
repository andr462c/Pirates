extends Node2D

@onready var players: Node2D = Utils.find_child(get_tree().root, "Players")
var shoot_direction = Vector2(0, 0)
var bullet_speed_multiplier = 1.0
var weapons = []
@onready
var sprite = $Sprite2D
@onready
var sprite_modulator = $SpriteModulator
@export
var health = 250
@onready var hit_sound = $HeavyHitSound
@onready
var air_strike_wave_timer = $AirStrikeWaveTimer
@onready
var single_air_strike_timer = $SingleAirStrikeTimer
@export
var air_strike_wave_delay = 10
@export
var single_air_strike_delay = 0.25
@export
var air_strikes_in_wave = 5
var strikes_in_cur_wave = 0
var airstrike = preload("res://objects/weapons/airstrike.tscn")
var turrets: Array[Node2D] = []
var death_sound = preload("res://objects/sounds/warship_killed_sound.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapons = Utils.GetWeapons(self)
	air_strike_wave_timer.start(air_strike_wave_delay)
	for w in weapons:
		if w.is_in_group("Turret"):
			turrets.append(w)
	for i in range(len(turrets)):
		var t = turrets[i]
		var timer: Timer = t.reload_timer
		var offset_fraction = i / float(len(turrets))
		timer.stop()
		timer.start(timer.wait_time * offset_fraction)
		t.can_shoot = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pirates: Array[Node2D] = []
	for c in players.get_children():
		pirates.append(c)
	var nearest_pirate = Utils.find_nearest(global_position, pirates)
	if nearest_pirate == null:
		return
		
	var direction = (nearest_pirate.global_position - global_position).normalized()
	var angle = atan2(direction.x, -direction.y)
	# global_rotation = atan2(direction.x, -direction.y)
	
	shoot_direction = Vector2.from_angle(angle - PI/2)
	for weapon in weapons:
		weapon.update_stats(self)
		weapon.shoot()


func take_damage(damage: float):
	health -= damage
	if hit_sound != null:
		hit_sound.play()
	sprite_modulator.modulate(sprite)
	get_node("/root/Main/Healthbars/EnemyHealth").value -= max(damage, 0)
	if health <= 0:
		get_tree().root.add_child(death_sound.instantiate())
		queue_free()


func _start_air_strike_wave():
	air_strike_wave_timer.stop()
	single_air_strike_timer.start(single_air_strike_delay)

func _air_strike():
	strikes_in_cur_wave += 1
	print("AIR STRIKE ", strikes_in_cur_wave)
	get_tree().root.add_child(airstrike.instantiate())
	if strikes_in_cur_wave == air_strikes_in_wave:
		strikes_in_cur_wave = 0
		single_air_strike_timer.stop()
		air_strike_wave_timer.start(air_strike_wave_delay)
