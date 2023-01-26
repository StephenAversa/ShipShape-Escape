extends Node

onready var timer = $Timer
#onready var level_planet = $Planet
onready var camera = $CameraController
onready var level_start = true
onready var player = preload("res://Player/Player.tscn")
onready var teleporter = preload("res://Teleporter.tscn")
onready var crate = preload("res://Crate.tscn")
onready var spikes = preload("res://Spikes.tscn")
onready var enemy1 = preload("res://Enemy1.tscn")
onready var enemy2 = preload("res://Enemy2.tscn")
onready var grass = preload("res://Grass.tscn")
onready var trees = preload("res://TreeProps.tscn")


#Ship
onready var ship = preload("res://Ship.tscn")
onready var ship_part1 = preload("res://ShipPart1.tscn")
onready var ship_part2 = preload("res://ShipPart2.tscn")
onready var ship_part3 = preload("res://ShipPart2.tscn")


var enemy_chance = ["Enemy1","Enemy1","Enemy1","Enemy1","Enemy1","Enemy2","Enemy2","Enemy3","Enemy3"]
var world_options = ["small", "medium"]
var world_dictionary ={
	"small" : {
		"spawn_points" : 8,
		"grass_spawn_points" : 28,
		"spike_min": 1,
		"spike_max": 3,
		"enemy_min": 0,
		"enemy_max": 2,
		"grass_min": 20,
		"grass_max": 30,
		"tree_min": 1,
		"tree_max": 5,
		"crates" : 3
	},
	"medium" :{
		"spawn_points" : 18,
		"spike_min": 3,
		"spike_max": 7,
		"enemy_min": 1,
		"enemy_max": 5,
		"grass_min": 30,
		"grass_max": 50,
		"tree_min": 5,
		"tree_max": 15,
		"crates" : 3
	}
}


var current_ship
var level_planet
var smoke
var can_tick = false
var game_over = false

signal level_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Globals.level_start = true
	pass

func _process(delta):
	if is_instance_valid(level_planet):
		get_tree().call_group("gravity","update_gravity_location",level_planet.global_position)
	
	if Globals.level_start == true:
		generate_level()
	
	if Globals.collected_tools == Globals.all_tools:
		if is_instance_valid(smoke):
			smoke.emitting = false
		Globals.broken = false
	
	if Globals.temp <= 0 and !game_over:
		game_over = true
		game_over()
	
	if Globals.temp > 100:
		Globals.temp = 99.5

func _on_Ship_player_spawn(position):
	smoke.emitting = true
	can_tick = true
	var spawn = player.instance()
	add_child(spawn)
	camera.position = spawn.position
	spawn.global_position = position
	spawn.hurtbox.disabled = true
	spawn.vuln_timer.start(2)
	spawn.connect("level_done", self, "_on_Level_done")
	remove_child(camera)
	spawn.add_child(camera)
	Globals.broken = true

func _on_Level_done(done):
	if (done):
		can_tick = false
		current_ship.out()
	
func _on_Next_level():
	delete_children(self)
	SceneTransition.change_scene("res://World.tscn")
	Globals.level += 1

func generate_level():
	Globals.collected_tools = 0
	var planet_size = world_options[randi() % 2]
	var planet_instance = load("res://Planets/Planet_"+planet_size+".tscn").instance()
	add_child(planet_instance)
	level_planet = planet_instance
	
	#get spawn points
	var circle_points = create_circle_array(world_dictionary[planet_size]["spawn_points"])
	add_hazards(world_dictionary[planet_size], circle_points)
	
	var tele_location = planet_instance.get_node("Landing").global_position
	smoke = planet_instance.get_node("Particles2D")
	camera.position = tele_location
	
	
	##SHIP TESTING
	var ship_instance = ship.instance()
	current_ship = ship_instance
	ship_instance.land_position = tele_location
	ship_instance.global_position = Vector2(tele_location.x-600,tele_location.y-300)
	ship_instance.connect("player_spawn", self, "_on_Ship_player_spawn")
	ship_instance.connect("next_level", self, "_on_Next_level")
	add_child(ship_instance)
	
	Globals.level_start = false

static func delete_children(node):
	for n in node.get_children():
		if !(n is Camera2D || n is AudioStreamPlayer2D):
			node.remove_child(n)
			n.queue_free()


func add_hazards(level, circle_array):
	circle_array.shuffle()
	var check_array = []
	check_array.resize(circle_array.size())
	check_array.fill(0)
	var spike_counter = randi() % level["spike_max"] + level["spike_min"]
	var enemy_counter = clamp((randi() % level["enemy_max"] + level["enemy_min"] + (Globals.level/5)),0,circle_array.size())
	var grass_counter = randi() % level["grass_max"] + level["grass_min"]
	var tree_counter = randi() % level["tree_max"] + level["tree_min"]
	#var direct_state = get_world().direct_space_state
	#Crates
	spawn_randomly(level_planet,1, "ShipPart1")
	spawn_randomly(level_planet,1, "ShipPart2")
	spawn_randomly(level_planet,1, "ShipPart3")
	#Spikes
	spawn_with_points(level_planet,spike_counter,check_array,circle_array,"Spikes")
	#Enemies
	circle_array.shuffle()
	check_array.fill(0)
	spawn_enemies(level_planet,enemy_counter,check_array,circle_array)
	#Grass
	spawn_randomly(level_planet,grass_counter,"Grass")
	spawn_randomly(level_planet,tree_counter,"TreeProps")
	

func create_circle_array(steps):
	var circle_array = []
	for i in (steps+1):
		circle_array.push_back( 5*PI/3 + ((5*PI/(3*steps)) * i))
	return circle_array
	
func spawn_with_points(planet,counter,check_array,circle_array,item):
	var center = planet.global_position
	var radius = planet.get_node("SpawnCircle/CollisionShape2D").shape.radius
	if item == "Enemy2":
		print("gotem")
	item = load("res://"+item+".tscn")
	for i in counter:
		if (!check_array[i] == 1):
			var angle = circle_array[i]
			check_array[i] = 1
			var direction = Vector2(cos(angle), sin(angle))
			var pos = center + direction * radius
			var item_instance = item.instance()
			add_child(item_instance)
			item_instance.global_position = pos
	return check_array

func spawn_randomly(planet, counter, item):
	item = load("res://"+item+".tscn")
	for i in counter:
		var center = planet.global_position
		var radius = planet.get_node("SpawnCircle/CollisionShape2D").shape.radius
		var angle = rand_range(5*PI/3,10*PI/3)
		var direction = Vector2(cos(angle), sin(angle))
		var pos = center + direction * radius
		var item_instance = item.instance()
		add_child(item_instance)
		item_instance.global_position = pos

func spawn_enemies(planet,counter,check_array,circle_array):
	var center = planet.global_position
	var radius = planet.get_node("SpawnCircle/CollisionShape2D").shape.radius
	for i in counter:
		if (!check_array[i] == 1):
			var angle = circle_array[i]
			check_array[i] = 1
			var direction = Vector2(cos(angle), sin(angle))
			var pos = center + direction * radius
			var item = load("res://"+choose(enemy_chance)+".tscn")
			var item_instance = item.instance()
			add_child(item_instance)
			item_instance.global_position = pos
	return check_array

func choose(array):
	var item =  array[randi() % array.size()]
	return item


func _on_Timer_timeout():
	if (can_tick):
		Globals.temp -= 1.15

func game_over():
	SceneTransition.change_scene("res://GameOver.tscn")
	SoundManager.stop()
