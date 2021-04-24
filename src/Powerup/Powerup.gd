extends Area2D

enum PW_TYPE {SHIELD, SHOCK, DASH}

var power_type = null
var power_name := ""


func _ready():
	randomize()
	var power_index = randi() % PW_TYPE.size()
	power_type = PW_TYPE.values()[power_index]
	power_name = PW_TYPE.keys()[power_index].to_lower()
	$Sprite.frame = power_type


func _on_Powerup_body_entered(player):
	player.actual_item = power_name
	queue_free()
