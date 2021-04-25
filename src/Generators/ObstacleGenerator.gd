extends Node2D

const Oursin = preload("res://src/Obstacle/Oursin.tscn")
const Anguille = preload("res://src/Obstacle/Anguille.tscn")
const Algue = preload("res://src/Obstacle/Algue.tscn")
const Powerup = preload("res://src/Powerup/Powerup.tscn")

onready var range_left = $RangeLeft
onready var range_right = $RangeRight
onready var range_down = $RangeDown
onready var instance_node = $Instances

func start():
	$MalusTimer.start()
	$PowerupTimer.start()
	$OursinTimer.start()
	$Particles2D.emitting = true
	$Particles2D.visible = true

func stop():
	for inst in instance_node.get_children():
		inst.queue_free()
	$MalusTimer.stop()
	$PowerupTimer.stop()
	$OursinTimer.stop()
	$Particles2D.emitting = false
	$Particles2D.visible = false	

func generate_oursin():
	var inst = Oursin.instance()
	var pos_x = rand_range(range_down.start.x, range_down.end.x)
	inst.start(Vector2(pos_x, range_down.start.y), Vector2.UP)
	instance_node.add_child(inst)
	
func generate_malus():
	var inst = [Anguille, Algue][randi() % 2].instance()
	var final_pos = Vector2(
		[range_left.start.x, range_right.start.x][randi() % 2],
		rand_range(range_left.start.y, range_left.end.y)
	)
	var velocity = Vector2.RIGHT if final_pos.x < 0 else Vector2.LEFT
	inst.start(final_pos, velocity)
	instance_node.add_child(inst)

func generate_powerup():
	var inst = Powerup.instance()
	var pos_x = rand_range(range_down.start.x, range_down.end.x)
	inst.start(Vector2(pos_x, range_down.start.y), Vector2.UP)
	instance_node.add_child(inst)

func _on_OursinTimer_timeout():
	generate_oursin()


func _on_MalusTimer_timeout():
	generate_malus()


func _on_PowerupTimer_timeout():
	generate_powerup()
