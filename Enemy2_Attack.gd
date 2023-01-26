extends EnemyState

# Virtual function. Corresponds to the `_process()` callback.
func update(delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	if !enemy2.attack_ray_check.is_colliding():
		enemy2.velocity.y = 70
	else:
		enemy2.velocity.y = 0
	
	enemy2.rotation = (enemy2.position.direction_to(enemy2.land).angle() - PI/2)
	enemy2.velocity.x =  lerp(enemy2.velocity.x,enemy2.direction * enemy2.attack_speed,enemy2.friction * delta)
	enemy2.velocity = enemy2.move_and_slide(enemy2.velocity.rotated(enemy2.rotation),-enemy2.transform.y)
	enemy2.velocity = enemy2.velocity.rotated(-enemy2.rotation)
	
	if (enemy2.back_to_idle):
		state_machine.transition_to("Enemy_Idle")

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
