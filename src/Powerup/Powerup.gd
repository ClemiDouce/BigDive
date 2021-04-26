extends Area2D

const SPEED = 50

enum PW_TYPE {SHIELD, SHOCK, DASH}

var power_type = null
var power_name := ""
var velocity := Vector2.ZERO



func _ready():
	randomize()
	var power_index = randi() % PW_TYPE.size()
	power_type = PW_TYPE.values()[power_index]
	power_name = PW_TYPE.keys()[power_index].to_lower()
	$Sprite.frame = power_type

func start(pos, vel):
	position = pos
	velocity = vel * SPEED

func _physics_process(delta):
	position += velocity * delta

func _on_Powerup_body_entered(player):
	if player.activated:
		player.actual_item = power_name
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
