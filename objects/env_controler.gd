extends Node2D

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	# "physics/2d/default_gravity" is what you have copied
	# Set the default gravity direction to `Vector2(0, 1)`.
	# Set the default gravity strength to 980.
	var force = sin(time)*50
	#PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, force)
	#PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(-1,1).normalized())
