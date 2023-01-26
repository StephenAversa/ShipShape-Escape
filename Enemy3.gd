extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var ray_check = $RayCast2D
onready var ground_check = $GroundCheck
onready var back_up_timer = $BackUpTimer
onready var dust = $CPUParticles2D

var can_go_up = true
var can_drop = false
var land = Vector2.ZERO
var velocity = Vector2.ZERO
var gravity = 3500
var collide 

var state = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("wiggle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = (position.direction_to(land).angle() - PI/2)
	collide = ray_check.get_collider()
	if (state == 0):
		if ray_check.is_colliding():
			velocity.y = -100
		else:
			velocity.y = 0
			can_drop = true
			anim.play("wiggle")
		
		if is_instance_valid(collide):
			if (collide.is_in_group("player") && can_drop):
				can_go_up = false
				can_drop = false
				state = 1
				anim.play("drop")
	elif (state == 1):
		velocity.y += gravity * delta
		if ground_check.is_colliding():
			dust.emitting = true
			state = 2
			back_up_timer.start(2)
	elif (state == 2):
		if (can_go_up):
			state = 3
			anim.play("up")
	elif (state == 3):
		if ray_check.is_colliding():
			velocity.y = -100
		else:
			state = 0
		
	velocity.x = 0
	var snap = transform.y * 1
	velocity = move_and_slide(velocity.rotated(rotation))
	velocity = velocity.rotated(-rotation)
	

		
#	pass
func update_gravity_location(planet):
	land = planet


func _on_BackUpTimer_timeout():
	can_go_up = true


func _on_SpikeCheck_body_entered(body):
	if body.is_in_group("spikes"):
		body.delete_me()
