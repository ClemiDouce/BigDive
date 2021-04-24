extends KinematicBody2D

onready var shock_wave_area = $ShockArea

const SPEED = 200

var is_slowed = false
var is_shocked = false

var velocity = Vector2.ZERO


func _ready():
	pass
	
func _physics_process(delta):
	move(delta)
	animate()

func move(delta):
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	direction = direction.normalized()
	velocity = direction * SPEED
	if is_shocked:
		velocity *= -1
	elif is_slowed:
		velocity /= 2
	move_and_slide(velocity, Vector2.ZERO)

func animate():
	if velocity.x > 0:
		rotation_degrees = -45
	elif velocity.x < 0:
		rotation_degrees = 45
	else:
		rotation_degrees = 0

func use_shock_wave():
	var bodies = shock_wave_area.get_overlapping_bodies()
	if bodies > 0:
		for bodie in bodies:
			bodie.destroy()

func use_dash(direction):
	pass
