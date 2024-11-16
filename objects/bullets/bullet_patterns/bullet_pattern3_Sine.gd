extends BulletPattern

var time = 0
@export var waveFrequency = 5.0
@export var waveAmplitude = 3.0

func add_pattern_force(rigidbody: RigidBody2D, delta: float):
	time += delta
	var displacement = cos(time * waveFrequency) * waveAmplitude
	 # Create a perpendicular vector to the direction
	var perpendicular = rigidbody.direction.rotated(PI / 2).normalized()
	# Apply the velocity
	rigidbody.linear_velocity +=  perpendicular * displacement
