extends Node2D

var current_container
var container_preload = preload("res://objects/obstacles/container.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.is_stopped():
		var container: RigidBody2D = container_preload.instantiate()
		current_container = container
		container.position = position
		container.set_collision_layer_value(1, false)
		container.set_collision_mask_value(1, false)
		add_child(container)
		container.add_child(preload("res://objects/bullets/detontor.tscn").instantiate())
		container.apply_impulse(Vector2.from_angle(randf_range(-PI, PI))*700)
		$Timer.start()
		$containertimer.start()
		
func _on_containertimer_timeout():
	if current_container != null:
		current_container.set_collision_layer_value(1, true)
		current_container.set_collision_mask_value(1, true)
