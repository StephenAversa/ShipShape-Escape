extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
var drop = false

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
			drop = true

# Virtual function. Corresponds to the `_process()` callback.
func update(delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	if (player.item != null):
		player.item.global_transform.origin = Vector2(player.throw_point.global_position.x,player.throw_point.global_position.y)
	player.rotation = (player.position.direction_to(player.gravity_point).angle() - PI/2)
	if (!is_zero_approx(player.get_input_direction())):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction()  * player.speed, player.air_friction * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, float(0), player.air_friction * delta)
	player.velocity.y += player.gravity * delta
	var snap = player.transform.y * 12
	player.velocity = player.move_and_slide_with_snap(player.velocity.rotated(player.rotation),
					snap, -player.transform.y, true, 4, PI/3,false)
	player.velocity = player.velocity.rotated(-player.rotation)
	
	if player.is_on_floor():
		if (is_zero_approx(player.get_input_direction())):
			state_machine.transition_to("Carry_Idle")
		else:
			state_machine.transition_to("Carry_Run")
	
	if player.hurt:
		state_machine.transition_to("Hurt", {no_sound = true})
		drop = true
	
	if player.bounce:
		player.velocity.y = -player.jump_speed/1.5
		SoundManager.play_sound(SoundManager.BOUNCE)
		player.bounce = false
		Globals.bounces += 1
		
	if (drop):
		player.item.global_transform.origin =Vector2(player.throw_point.global_position.x,player.throw_point.global_position.y)
		player.item.get_node("CollisionShape2D").disabled=false
		player.item = null
		player.is_carrying = false
		drop = false
		state_machine.transition_to("Idle")
	#DRAWING
	player.sprite.scale.y = range_lerp(abs(player.velocity.y), 0, abs(player.jump_speed), 1.75, 2.75)
	player.sprite.scale.x = range_lerp(abs(player.velocity.y), 0, abs(player.jump_speed), 2.25, 1.75)

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	animation_player.play("jump_up")
	player.hit_the_ground = false
	if (msg.has("do_jump")):
		player.velocity.y = -player.jump_speed
		player.move_and_slide(player.velocity,Vector2.UP)
		SoundManager.play_sound(SoundManager.JUMP)

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
	

