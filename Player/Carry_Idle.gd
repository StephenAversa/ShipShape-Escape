extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
var drop = false

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print(player.item.name)
		if player.on_teleporter:
			if "ShipPart" in player.item.name:
				if ("1" in player.item.name):
					player.fix_part(1)
				elif ("2" in player.item.name):
					player.fix_part(2)
				elif ("3" in player.item.name):
					player.fix_part(3)
				player.item.delete_me()
				player.item = null
				player.is_carrying = false
				state_machine.transition_to("Idle")
				Globals.collected_tools += 1
		else:
			drop = true
			SoundManager.play_sound(SoundManager.RELEASE)


# Virtual function. Corresponds to the `_process()` callback.
func update(delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	if (player.item != null):
		player.item.global_transform.origin = Vector2(player.throw_point.global_position.x,player.throw_point.global_position.y)
	player.velocity.x = lerp(player.velocity.x, float(0),player.friction * delta)
	
	if !player.is_on_floor():
		state_machine.transition_to("Carry_Air")
		return
	else:
		player.rotation = player.get_floor_normal().angle() + PI/2
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Carry_Air", {do_jump = true})
	
	var snap = player.transform.y * 12
	player.velocity = player.move_and_slide_with_snap(player.velocity.rotated(player.rotation),
					snap, -player.transform.y, true, 4, PI/3, false)
	player.velocity_previous = player.velocity
	player.velocity = player.velocity.rotated(-player.rotation)
	
	if !is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Carry_Run")
	
	if player.hurt:
		state_machine.transition_to("Hurt", {no_sound = true})
		drop = true
	
	if (drop):
		player.item.global_transform.origin =Vector2(player.throw_point.global_position.x,player.throw_point.global_position.y)
		player.item.get_node("CollisionShape2D").disabled=false
		player.item = null
		player.is_carrying = false
		drop = false
		state_machine.transition_to("Idle")
	#if is_zero_approx(player.get_input_direction()):
	#	state_machine.transition_to("Idle")

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	animation_player.play("idle")

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
