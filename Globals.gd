extends Node

var landed = false
var player_health = 3
var score = 0
var level_start = false
var level = 1
var broken = false
var collected_tools = 0
var all_tools = 3

var stuns = 0
var bounces = 0

var temp = 100

var wrenched = true

var part1 = false
var part2 = false
var part3 = false

signal fix_part(part)
signal update_world()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
