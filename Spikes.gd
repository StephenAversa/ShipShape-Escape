extends Node2D

var land = Vector2.ZERO

func _physics_process(delta):
	rotation = (position.direction_to(land).angle() - PI/2)
	
	#rotation = get_floor_normal().angle() + PI/2
			
func update_gravity_location(planet):
	land = planet

func delete_me():
	call_deferred("free")
