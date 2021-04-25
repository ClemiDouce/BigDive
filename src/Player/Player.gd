extends KinematicBody2D

onready var shock_wave_area = $ShockArea
onready var sprite = $Drone
onready var shield = $Bouclier
onready var shock_malus = $ShockedMalus
onready var shock_timer = $ShockTimer
onready var slow_timer = $SlowTimer
onready var shield_timer = $ShieldTimer
onready var shock_animation = $AnimationPlayer

const SPEED = 200
const ROTATION_SPEED = 10
const ROTATION_ANGLE = 33

var is_slowed = false setget set_is_slowed
var is_shocked = false setget set_is_shocked
var is_shielded = false setget set_is_shielded
export (bool) var activated = false

var actual_item = "" setget set_actual_item
var item_charge = 0 setget set_item_charge


var velocity = Vector2.ZERO


func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed('use_power') and !is_shielded:
		use_item()
	
func _physics_process(delta):
	if activated:
		move(delta)
		animate(delta)
	
func loose():
	queue_free()
	
func use_item():
	if actual_item == "":
		return
	match(actual_item):
		"shield":
			self.is_shielded = true
		"shock":
			use_shock_wave()
		'dash':
			print('Dash used')
	self.item_charge -= 1

func move(_delta):
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	direction = direction.normalized()
	velocity = direction * SPEED
	if is_shocked:
		velocity *= -1
	if is_slowed:
		velocity /= 2
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.ZERO)

func animate(delta):
	#TODO implement recul rotation
	if velocity.x > 0:
		rotation_degrees = lerp(rotation_degrees, -ROTATION_ANGLE, delta * ROTATION_SPEED)
	elif velocity.x < 0:
		rotation_degrees = lerp(rotation_degrees, ROTATION_ANGLE, delta * ROTATION_SPEED)
	else:
		rotation_degrees = lerp(rotation_degrees, 0, delta * ROTATION_SPEED)

func use_shock_wave():
	shock_animation.play("shock")
	var bodies = shock_wave_area.get_overlapping_bodies()
	if bodies.size() > 0:
		print('Bodies count : ' + str(bodies.size()))
		for bodie in bodies:
			bodie.destroy()

func use_dash(_direction):
	pass
	
func set_is_slowed(new_value):
	is_slowed = new_value
	if new_value == true:
		sprite.frame = 2
		slow_timer.start()
	else:
		sprite.frame = 0
		slow_timer.stop()

func set_is_shocked(new_value):
	is_shocked = new_value
	shock_malus.visible = new_value
	if is_shocked == true:
		sprite.frame = 1
		shock_timer.start()
	else:
		sprite.frame = 0
		shock_timer.stop()
	
func set_is_shielded(new_value):
	if new_value == true:
		self.is_shocked = false
		self.is_slowed = false
		shield_timer.start()
		sprite.frame = 3
	else:
		sprite.frame = 0
		
	shield.visible = new_value
	is_shielded = new_value

func set_actual_item(new_value):
	Global.emit_signal("get_item", new_value)
	actual_item = new_value
	item_charge = 3

func set_item_charge(new_value):
	item_charge = new_value
	if new_value == 0:
		self.actual_item = ""

func _on_ShieldTimer_timeout():
	self.is_shielded = false


func _on_ShockTimer_timeout():
	self.is_shocked = false


func _on_SlowTimer_timeout():
	self.is_slowed = false
