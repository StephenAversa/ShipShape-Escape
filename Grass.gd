extends RigidBody2D

var land = Vector2.ZERO

func _physics_process(delta):
	rotation = (position.direction_to(land).angle() - PI/2)

func update_gravity_location(planet):
	land = planet
