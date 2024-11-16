extends Node2D

@export var angular_factor = 0.02
@export var speed = 40_000
@export var points = [Vector2(50, 200), Vector2(500, 200)]
var parent
var cur_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta):
	var parent = get_parent()
	if parent == null:
		return
	
	var p = points[cur_idx]
	var direction: Vector2 = (p - parent.global_position).normalized()
	var angle_diff = atan2(direction.x, -direction.y) - parent.rotation
	angle_diff = wrap(angle_diff, -PI, PI)
	parent.angular_velocity = angle_diff / delta * 0.02
	parent.apply_force(Vector2.from_angle(parent.rotation - PI/2) * speed)
	if (global_position - p).length() < 60:
		cur_idx = (cur_idx + 1) % len(points)

#func apply_movement(delta: float, rigid_body: RigidBody2D) -> void:
	#var parent = get_parent()
	#if parent == null:
		#return
	#
	#var p = points[cur_idx]
	#var direction: Vector2 = (p - rigid_body.global_position).normalized()
	#var angle_diff = atan2(direction.x, -direction.y) - rigid_body.rotation
	#angle_diff = wrap(angle_diff, -PI, PI)
	#rigid_body.angular_velocity = angle_diff / delta * 0.02
	#rigid_body.apply_force(Vector2.from_angle(rigid_body.rotation - PI/2) * speed)
	#if (global_position - p).length() < 60:
		#cur_idx = (cur_idx + 1) % len(points)
