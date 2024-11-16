extends BulletPattern

var time = 0
@export var waveFrequency = 5.0
@export var waveAmplitude = 3.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func add_pattern_force(rigidbody: RigidBody2D, delta: float):
	time += delta
	var displacement = sin(time * waveFrequency) * waveAmplitude
	var direction = rigidbody.linear_velocity.normalized()
	var orthogonal_direction = Vector2(0, 1).cross(direction)
	rigidbody.linear_velocity += direction * displacement
