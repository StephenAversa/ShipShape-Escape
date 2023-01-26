extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player.item && !player.is_carrying:
			player.is_carrying = true
			player.item.get_node("CollisionShape2D").disabled=true
			SoundManager.play_sound(SoundManager.PICKUP)
			state_machine.transition_to("Carry_Idle", {carry = player.item})
		elif player.on_teleporter && !Globals.broken:
			player.emit_signal("level_done",true)
			var camera = player.get_node("CameraController")
			player.remove_child(camera)
			camera.global_position = player.global_position
			player.get_parent().add_child(camera)
			player.queue_free()

# Virtual function. Corresponds to the `_process()` callback.
func update(delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		state_machine.transition_to("Air")
		return
	else:
		player.rotation = player.get_floor_normal().angle() + PI/2
	
	if (!is_zero_approx(player.get_input_direction())):
		player.velocity.x = lerp(player.velocity.x,player.get_input_direction() * player.speed,player.friction * delta)
	player.velocity.y += player.gravity * delta
	var snap = player.transform.y * 12
	player.velocity = player.move_and_slide_with_snap(player.velocity.rotated(player.rotation),
					snap, -player.transform.y, true, 4, PI/3, false)
	player.velocity_previous = player.velocity
	player.velocity = player.velocity.rotated(-player.rotation)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Idle")
	
	if player.hurt:
		state_machine.transition_to("Hurt")
	
	if !player.hit_the_ground and player.is_on_floor():
		player.hit_the_ground = true
		player.sprite.scale.x = range_lerp(abs(player.velocity_previous.y), 0, abs(1700), 2.2, 3.0)
		player.sprite.scale.y = range_lerp(abs(player.velocity_previous.y), 0, abs(1700), 1.8, 1.5)

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	animation_player.play("run")

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
