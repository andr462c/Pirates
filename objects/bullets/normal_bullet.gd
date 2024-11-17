extends RigidBody2D

var speed	
var deathtimer
var direction: Vector2
var sprite: Sprite2D
var damage
var kill_timer: float
var bullet_pattern: BulletPattern
var isplayerbullet: bool = false
var knockback = 0.0

func init(_position: Vector2, _speed: float, _direction: Vector2, dont_collide_with: Array, _damage: float, _kill_timer: float, _bullet_pattern: BulletPattern):
	sprite = $Sprite2D
	for coll in dont_collide_with:
		print("name ", coll.name)
		if coll.name == "P1" or coll.name == "P0":
			knockback = coll.knockback
			isplayerbullet = true
			sprite.modulate = Color(0.75, 0, 0, 0.8)
	print("isplayerbullet ", isplayerbullet)
	if not isplayerbullet:
		var n = dont_collide_with[0]
		while n.get_parent() != null:
			n = n.get_parent()
		dont_collide_with.append_array(Utils.get_all_enemy_stuff(n))
	position = _position
	speed =	 _speed	
	direction = _direction
	
	damage = _damage
	kill_timer = _kill_timer
	Utils.add_collisions_ignore(self, dont_collide_with)
	bullet_pattern = _bullet_pattern

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction*speed*mass)
	sprite.rotation = direction.angle()
	$killtimer.start(kill_timer)


func _on_body_entered(body):
	if body.has_method("apply_impulse"):
		body.apply_impulse(direction.normalized()*knockback)
	if body.has_method("take_damage"):	
		body.take_damage(damage)
	queue_free()

func _integrate_forces(state):
	if bullet_pattern != null:
		bullet_pattern.add_pattern_force(self, 0.01)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
	#if bullet_pattern != null:
		#bullet_pattern.add_pattern_force(self, delta)

func _on_killtimer_timeout():
	queue_free()	
