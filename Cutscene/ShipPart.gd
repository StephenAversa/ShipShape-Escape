extends Sprite


var gravity = Vector2(0,150)
var upshot = Vector2(rand_range(-40,40),-100)
var velocity = Vector2()
var up = false
var down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if up:
		velocity = upshot
		set_position(get_position() + velocity * delta)
		rotation -= .2
	if down:
		velocity += gravity * delta
		rotation += .2
		set_position(get_position() + velocity * delta)
