extends Node2D

const Oursin = preload("res://src/Obstacle/Oursin.tscn")
const Anguille = preload("res://src/Obstacle/Anguille.tscn")
const Algue = preload("res://src/Obstacle/Algue.tscn")
const Powerup = preload("res://src/Powerup/Powerup.tscn")

const OURSIN_GEN : float = 2.0
const MALUS_GEN : float = 4.0
const POWERUP_GEN : float = 8.0

const OURSIN_DIF : float = 0.08
const MALUS_DIF : float = 0.15
const POWERUP_DIF : float = 0.30

onready var range_left = $RangeLeft
onready var range_right = $RangeRight
onready var range_down = $RangeDown
onready var instance_node = $Instances
onready var tween = $Tween
onready var particle = $Particles2D
onready var player = get_node("../Player")


var difficulty_level = 0 setget set_difficulty_level
var oursin_spawn = 0

func start():
	randomize()
	$MalusTimer.start()
	$PowerupTimer.start()
	$OursinTimer.start()
	particle.emitting = true
	particle_visibility_in()

func stop():
	for inst in instance_node.get_children():
		inst.queue_free()
	$MalusTimer.stop()
	$PowerupTimer.stop()
	$OursinTimer.stop()
	particle.emitting = false
	particle_visibility_out()
	self.difficulty_level = 0
	
func particle_visibility_out():
	tween.interpolate_property(particle.process_material, 'color', null, Color(1,1,1,0), 0.2)
	tween.start()
	
func particle_visibility_in():
	tween.interpolate_property(particle.process_material, 'color', null, Color(1,1,1,0.12), 1)
	tween.start()

func generate_oursin(nbr:int = 1, speed = 100):
# warning-ignore:integer_division
	var marge = 20 / nbr
	var width = (range_down.end.x - range_down.start.x) / nbr
	for i in range(nbr):
		var inst = Oursin.instance()
		var final_pos = Vector2(0, range_down.start.y)
		if oursin_spawn % 3 == 0:
			final_pos.x = player.position.x
		else:
			final_pos.x = rand_range(
				range_down.start.x + (i*width) + marge,
				(i*width) + width - marge
			)
		inst.start(final_pos, Vector2.UP, speed)
		instance_node.add_child(inst)
		oursin_spawn += 1
	
func generate_malus(nbr:int = 1, speed = 100):
	for i in range(nbr):
		var inst = [Anguille, Algue, Algue][randi() % 3].instance()
		var final_pos = Vector2(
			[range_left.start.x, range_right.start.x][randi() % 2],
			rand_range(range_left.start.y, range_left.end.y)
		)
		var velocity = Vector2.RIGHT if final_pos.x < 0 else Vector2.LEFT
		inst.start(final_pos, velocity, speed)
		instance_node.add_child(inst)

func generate_powerup():
	var inst = Powerup.instance()
	var pos_x = rand_range(range_down.start.x + 20, range_down.end.x - 20)
	inst.start(Vector2(pos_x, range_down.start.y), Vector2.UP)
	instance_node.add_child(inst)

func set_difficulty_level(new_value):
	difficulty_level = new_value
	if Global.difficulty_mode == "easy":
		$MalusTimer.wait_time = MALUS_GEN - (difficulty_level * MALUS_DIF)
		$PowerupTimer.wait_time = POWERUP_GEN + (difficulty_level * POWERUP_DIF)
		$OursinTimer.wait_time = OURSIN_GEN - (difficulty_level * OURSIN_DIF)
	else:
		$MalusTimer.wait_time = MALUS_GEN - (difficulty_level * (MALUS_DIF * 2))
		$PowerupTimer.wait_time = POWERUP_GEN + (difficulty_level * (POWERUP_DIF * 2))
		$OursinTimer.wait_time = OURSIN_GEN - (difficulty_level * (OURSIN_DIF))

func _on_OursinTimer_timeout():
	if Global.difficulty_mode == "hard":
		if difficulty_level >= 8:
			generate_oursin(3, 70)
		elif difficulty_level >= 5:
			generate_oursin(2, 100)
		else:
			generate_oursin(1)
	else:
		if difficulty_level >= 7:
			generate_oursin(2, 100)
		elif difficulty_level >= 4:
			generate_oursin(2, 80)
		else:
			generate_oursin(1, 60)


func _on_MalusTimer_timeout():
	if Global.difficulty_mode == "hard":
		if difficulty_level >= 6:
			generate_malus(2, 70)
		else:
			generate_malus(1)
	else:
		generate_malus(1)


func _on_PowerupTimer_timeout():
	generate_powerup()
