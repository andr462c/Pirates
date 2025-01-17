extends RigidBody2D

var speed	
var deathtimer
var direction: Vector2
var sprite: Sprite2D
var kill_timer: float
var bullet_pattern: BulletPattern

var explosion_scene = preload("res://objects/bullets/explosion.tscn")
var missile_explosion_sound = preload("res://objects/sounds/missile_explode_sound.tscn")

func init(_position: Vector2, _speed: float, _direction: Vector2, dont_collide_with: Array, _damage: float, _kill_timer: float, _bullet_pattern: BulletPattern):
	position = _position
	speed =	 _speed	
	direction = _direction
	sprite = $Sprite2D
	var isplayerbullet = false
	for coll in dont_collide_with:
		if coll.name == "P0" or coll.name == "P1":
			isplayerbullet = true
	if not isplayerbullet:
		var n = dont_collide_with[0]
		while n.get_parent() != null:
			n = n.get_parent()
		dont_collide_with.append_array(Utils.get_all_enemy_stuff(n))
	Utils.add_collisions_ignore(self, dont_collide_with)
	kill_timer = _kill_timer
	bullet_pattern = _bullet_pattern

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction*speed*mass)
	sprite.rotation = direction.angle()
	$killtimer.wait_time = kill_timer

func _on_body_entered(body):
	# body.apply_impulse(direction*400, global_position)
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	explosion.add_child(missile_explosion_sound.instantiate())
	get_tree().root.call_deferred("add_child", explosion)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bullet_pattern != null:
		bullet_pattern.add_pattern_force(self, delta)

func _on_killtimer_timeout():
	queue_free()	
