class_name Player
extends KinematicBody2D

export var speed = 250
export var jump_speed = 600
export var gravity = 2000
export var accel = 100
export var friction = 20
export var air_friction = 5
var gravity_point = Vector2.ZERO
var is_jumping = false
var is_carrying = false
var on_teleporter = false
var bounce = false
var hurt = false
var stunned = false
var enemy
var item

signal level_done(false)

onready var sprite = $Sprite
onready var throw_point = $ThrowPoint
onready var sounds = $AudioStreamPlayer
onready var feet = $Feet
onready var stun_timer = $StunTimer
onready var vuln_timer = $VulnerableTimer
onready var hurtbox = $Hurtbox/CollisionShape2D
onready var collision_box = $CollisionShape2D
onready var animation = $AnimationPlayer

var velocity_previous = Vector2()
var hit_the_ground = false

var velocity = Vector2.ZERO

func _process(delta):
	sprite.scale.x = lerp(sprite.scale.x, 2, 1 - pow(0.01, delta))
	sprite.scale.y = lerp(sprite.scale.y, 2, 1 - pow(0.01, delta))

func get_input_direction() -> float:
	var direction = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	if direction < 0:
		sprite.flip_h = true
		throw_point.position.x = -20
	if direction > 0:
		sprite.flip_h = false
		throw_point.position.x = 20
		
	return direction

func update_gravity_location(point):
	gravity_point = point

func _on_Pickup_body_entered(body):
	print(body.name)
	if !is_carrying:
		if body.is_in_group("item"):
			item = body


func _on_Pickup_body_exited(body):
	if !is_carrying:
		if body.is_in_group("item"):
			item = null


func _on_Pickup_area_entered(area):
	if area.is_in_group("ship"):
		on_teleporter = true

func _on_Pickup_area_exited(area):
	if area.is_in_group("ship"):
		on_teleporter = false


func _on_Feet_area_entered(area):
	if (area.is_in_group("bounce")):
		bounce = true

func _on_Feet_area_exited(area):
	if (area.is_in_group("bounce")):
		bounce = false

func fix_part(part):
	Globals.emit_signal("fix_part",part)


func _on_Hurtbox_area_entered(area):
	if (area.is_in_group("enemy_hitbox")):
		hurt = true
		enemy = area


func _on_StunTimer_timeout():
	hurt = false
	vuln_timer.start(2)

func _on_VulnerableTimer_timeout():
	hurtbox.disabled = false
	show_collisions()
	
func hide_collisions():
	set_collision_layer_bit(9,true)
	set_collision_mask_bit(9,true)
	#set_collision_layer_bit(0,false)
	set_collision_layer_bit(1,false)
	#set_collision_mask_bit(0,false)
	set_collision_mask_bit(1,false)
	set_collision_mask_bit(3,false)
	
func show_collisions():
	#set_collision_layer_bit(0,true)
	set_collision_layer_bit(1,true)
	#set_collision_mask_bit(0,true)
	set_collision_mask_bit(1,true)
	set_collision_mask_bit(3,true)
	set_collision_layer_bit(9,false)
	set_collision_mask_bit(9,false)






