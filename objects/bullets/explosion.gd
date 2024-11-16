extends Node2D

var bomb_strength = 2000
var damage_radius
var knockback_radius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var damage_shape = get_node("DamageArea/CollisionShape2D") as CollisionShape2D
	damage_radius = (damage_shape.shape as CircleShape2D).radius
	
	var knockback_shape = get_node("KnockbackArea/CollisionShape2D") as CollisionShape2D
	knockback_radius = (knockback_shape.shape as CircleShape2D).radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_knockback_area_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		var physics_body = body as RigidBody2D
		var to_boat = physics_body.position - position
		var inv_distance = scale.x * knockback_radius - to_boat.length()
		var impulse = inv_distance * to_boat.normalized()
		
		physics_body.apply_impulse(impulse * bomb_strength)
