extends Control

onready var char_timer = $NextCharTimer
onready var msg_timer = $NextMessageTimer
onready var msg_timer2 = $NextMessageTimer2
onready var next_level_timer = $NextLevel
onready var explode_timer = $ExplodeTimer
onready var cutscene_text = $Text
onready var ship = $Ship2
onready var ship_sprite = $Ship2/Ship
onready var fire = $Ship2/ThrusterParticles
onready var shipParts = $Ship2/ShipParts

var messages = ["The  sun  has  begun  drifting  away  from  your  planet",
				"You  put  together  a  makeshift  ship",
				"As  you  race  against  the  dropping  temperature,  your  ship  begins  to  rumble"]

var final_message = ["Find  the  ship  pieces",
					"Reassemble  your  vessel",
					""]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var typing_speed = .1
var read_time = 2
var current_message = 0
var current_char = 0
var display = ""

var shake = false
# Called when the node enters the scene tree for the first time.
func _ready():
	start_dialogue()
	
func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	char_timer.set_wait_time(typing_speed)
	char_timer.start()


func _process(delta):
	if shake:
		start_shake()
	get_input()

func get_input():
	if Input.is_action_just_pressed("jump"):
		SoundManager.stop()
		SceneTransition.change_scene("res://World.tscn")
		Globals.level = 1
		Globals.temp = 100
		SoundManager.play_sound(SoundManager.LEVEL)

func _on_NextCharTimer_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		cutscene_text.text = display
		current_char += 1
		SoundManager.play_sound(SoundManager.THUNK)
	else:
		char_timer.stop()
		msg_timer.one_shot = true
		msg_timer.set_wait_time(read_time)
		msg_timer.start()
		

func _on_NextMessageTimer_timeout():
	if current_message == len(messages) - 1:
		end_dialogue()
	else:
		current_message += 1
		display = ""
		current_char = 0
		char_timer.start()

func end_dialogue():
	shake = true
	explode_timer.set_wait_time(4)
	explode_timer.start()
	
func start_shake():
	randomize()
	var shake_amount = rand_range(-2,2)
	ship.global_position.x = ship.global_position.x + shake_amount
	shake_amount = rand_range(-2,2)
	ship.global_position.y = ship.global_position.y + shake_amount


func _on_ExplodeTimer_timeout():
	shake = false
	fire.emitting = false
	for n in shipParts.get_children():
		n.up = true
		yield(get_tree().create_timer(1),"timeout")
		n.up = false
		n.down = true
	msg_timer2.set_wait_time(2)
	msg_timer2.start()

func _on_NextMessageTimer2_timeout():
	messages = final_message
	current_message = 0
	display = ""
	current_char = 0
	char_timer.set_wait_time(typing_speed)
	char_timer.start()
	ship_sprite.down = true
	next_level_timer.set_wait_time(9)
	next_level_timer.start()


func _on_NextLevel_timeout():
	SoundManager.stop()
	SceneTransition.change_scene("res://World.tscn")
	Globals.level = 1
	Globals.temp = 100
	SoundManager.play_sound(SoundManager.LEVEL)
