extends BulletPattern

var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func add_pattern_force(rigidbody: RigidBody2D, delta: float):
	#self.rotated(5*sin(10.0))
	time += delta
	var displacement = cos(time * 5) * 3
	var direction = rigidbody.direction.normalized()
	rigidbody.linear_velocity += direction * displacement
