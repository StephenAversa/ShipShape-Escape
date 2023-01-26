extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)


func handle_input(event: InputEvent) -> void:
	pass

# Virtual function. Corresponds to the `_process()` callback.
func update(delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	player.rotation = (player.position.direction_to(player.gravity_point).angle() - PI/2)

	player.velocity.y += player.gravity * delta
	player.velocity.x = lerp(player.velocity.x, float(0),player.friction * delta)
	var snap = player.transform.y * 12
	player.velocity = player.move_and_slide_with_snap(player.velocity.rotated(player.rotation),
					snap, -player.transform.y, true, 4, PI/3,false)
	player.velocity = player.velocity.rotated(-player.rotation)
	player.hide_collisions()
	if player.is_on_floor():
		animation_player.play("stun")
	if player.is_on_floor() && !player.hurt:
		state_machine.transition_to("Idle")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	Globals.stuns += 1
	animation_player.play("jump_up")
	player.hit_the_ground = false
	player.velocity.y = -player.jump_speed/2
	player.move_and_slide(player.velocity,Vector2.UP)
	player.hurtbox.disabled = true
	player.hide_collisions()
	player.stun_timer.start(2)
	if !(msg.has("no_sound")):
		SoundManager.play_sound(SoundManager.HURT)

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
	

