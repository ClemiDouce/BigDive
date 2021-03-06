extends KinematicBody2D

onready var shock_wave_area = $ShockArea
onready var sprite = $Drone
onready var shield = $Bouclier
onready var shock_malus = $ShockedMalus
onready var shock_timer = $ShockTimer
onready var slow_timer = $SlowTimer
onready var shield_timer = $ShieldTimer
onready var shock_animation = $AnimationPlayer
onready var dash_particle = $DashParticle

const shield_sound = preload("res://assets/sounds/br_bouclier.wav")
const shield_lost = preload("res://assets/sounds/br_bouclier_eclate.wav")
const shock_sound = preload("res://assets/sounds/br_onde.wav")
const game_over = preload("res://assets/sounds/br_gameover.wav")
const dash_sound = preload("res://assets/sounds/br_dash.wav")


var SPEED = 200
const ROTATION_SPEED = 10
const ROTATION_ANGLE = 33

var ExplosionEffect = preload("res://src/Effect/ExplosionEffect.tscn")

var is_slowed = false setget set_is_slowed
var is_shocked = false setget set_is_shocked
var is_shielded = false setget set_is_shielded
var is_dashing = false
export (bool) var activated = false

var actual_item = "" setget set_actual_item
var item_charge = 0 setget set_item_charge


var velocity = Vector2.ZERO

signal player_dead

func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed('use_power') and activated:
		use_item()
	
func _physics_process(delta):
	if activated:
		move(delta)
	animate(delta)

func reset():
	self.is_shocked = false
	self.is_shielded = false
	self.is_slowed = false
	self.visible = false
	activated = false
	velocity = Vector2.ZERO
	self.item_charge = 0
	
func loose():
	MusicManager.play_sound(game_over)
	MusicManager.change_music('menu', 1)
	reset()
	var death_inst = ExplosionEffect.instance()
	get_parent().add_child(death_inst)
	death_inst.position = self.position
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("player_dead")
	
func use_item():
	if actual_item == "":
		return
	match(actual_item):
		"shield":
			self.is_shielded = true
			self.item_charge -= 1
		"shock":
			MusicManager.play_sound(shock_sound)
			use_shock_wave()
			self.item_charge -= 1
		'dash':
			if velocity != Vector2.ZERO:
				MusicManager.play_sound(dash_sound)
				use_dash()
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
		$Drone.rotation_degrees = lerp($Drone.rotation_degrees, -ROTATION_ANGLE, delta * ROTATION_SPEED)
	elif velocity.x < 0:
		$Drone.rotation_degrees = lerp($Drone.rotation_degrees, ROTATION_ANGLE, delta * ROTATION_SPEED)
	else:
		$Drone.rotation_degrees = lerp($Drone.rotation_degrees, 0, delta * ROTATION_SPEED)
	$MoveSound.volume_db = 12 if velocity != Vector2.ZERO else -60
#	if shock_timer.time_left < 2:
#		sprite.frame = 0 if shock_timer.time_left % 0.5 == 0 else 2
#	if shield_timer.time_left < 2:
#		sprite.frame = 0 if shield_timer.time_left % 0.5 == 0 else 3
#	if slow_timer.time_left < 2:
#		sprite.frame = 0 if shield_timer.time_left % 0.5 == 0 else 2
func use_shock_wave():
	shock_animation.play("shock")

func kill_shock():
	var bodies = shock_wave_area.get_overlapping_bodies()
	if bodies.size() > 0:
		for bodie in bodies:
			bodie.destroy()

func use_dash():
	var reverse_velocity = velocity.normalized() * -1
	var final_vector = Vector3(reverse_velocity.x, reverse_velocity.y, 0)
	dash_particle.process_material.set('direction', final_vector)
	dash_particle.emitting = true
	is_dashing = true
	SPEED *= 3
	$DashTimer.start()
	
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
		if activated:
			MusicManager.play_sound(shield_sound)
	else:
		sprite.frame = 0
		shield_timer.stop()
		if activated:
			MusicManager.play_sound(shield_lost)
		
	shield.visible = new_value
	is_shielded = new_value

func set_actual_item(new_value):
	Global.emit_signal("get_item", new_value)
	actual_item = new_value
	item_charge = 1

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


func _on_DashTimer_timeout():
	SPEED = 200
	is_dashing = false
