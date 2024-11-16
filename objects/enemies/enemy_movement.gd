extends Node2D

var angular_factor = 0.02
var speed = 40_000
var points = [Vector2(50, 200), Vector2(500, 200)]
var cur_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func apply_movement(delta: float, rigid_body: RigidBody2D) -> void:
	var p = points[cur_idx]
	var direction: Vector2 = (p - rigid_body.global_position).normalized()
	var angle_diff = atan2(direction.x, -direction.y) - rigid_body.rotation
	angle_diff = wrap(angle_diff, -PI, PI)
	rigid_body.angular_velocity = angle_diff / delta * 0.02
	rigid_body.apply_force(Vector2.from_angle(rigid_body.rotation - PI/2) * speed)
	if (global_position - p).length() < 10:
		cur_idx = (cur_idx + 1) % len(points)
