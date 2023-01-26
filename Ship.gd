extends Node2D

var land = true
var takeoff = false
var spawn = true
var land_position
var speed = 200

onready var panel = $ShipPieces/Panel
onready var back_panel = $ShipPieces/BackPanel
onready var thruster = $ShipPieces/Thruster
onready var thruster_particles = $ThrusterParticles
onready var timer = $NextLevelTimer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO

signal player_spawn(position)
signal next_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("fix_part", self, "on_Fix_Part")


func _process(delta):
	if (global_position.distance_to(land_position)) > 2 && land:
		var movement_vector = -(global_position - land_position).normalized() * speed
		#velocity =  lerp(velocity.x,-1 * speed,1)
		translate(movement_vector * delta)
	elif spawn:
		spawn = false
		emit_signal("player_spawn",global_position)
		land = false
	
	if takeoff:
		var movement_vector = -(global_position - Vector2(global_position.x+400,global_position.y-400)).normalized() * speed
		translate(movement_vector * delta)



func on_Fix_Part(part):
	if (part == 1):
		panel.visible = true
	elif (part == 2):
		back_panel.visible = true
	elif (part == 3):
		thruster.visible = true

func out():
	takeoff = true
	thruster_particles.emitting = true
	timer.start(4)
	
func _on_NextLevelTimer_timeout():
	Globals.temp += 18
	emit_signal("next_level")
