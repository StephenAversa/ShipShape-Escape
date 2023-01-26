extends Node

const JUMP = preload("res://Assets/Sounds/Jump2.mp3")
const BOUNCE = preload("res://Assets/Sounds/Jump3.mp3")
const HURT = preload("res://Assets/Sounds/Damage.mp3")
const PICKUP = preload("res://Assets/Sounds/HoldObject.mp3")
const RELEASE = preload("res://Assets/Sounds/ReleaseObject.mp3")
const THUNK = preload("res://Assets/Sounds/thunk1.mp3")

const LEVEL = preload("res://Assets/Sounds/Ice_Cave.mp3")
const MENU = preload("res://Assets/Sounds/Upgrade.mp3")

onready var audioPlayers = $AudioPlayers
# Called when the node enters the scene tree for the first time.
func play_sound(sound):
	for audioSteamPlayer in audioPlayers.get_children():
		if not audioSteamPlayer.playing:
			audioSteamPlayer.stream = sound
			if (sound == MENU):
				audioSteamPlayer.volume_db = -.9
			audioSteamPlayer.play()
			break
			
func stop():
	for audioSteamPlayer in audioPlayers.get_children():
		if audioSteamPlayer.playing:
			audioSteamPlayer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
