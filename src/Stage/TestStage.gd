extends Node2D

var score = 0 setget set_score
var level = 0



func _on_Timer_timeout():
	self.score += 1

func set_score(new_value):
	score = new_value
	$Label.text = "Score: " + str(score)
	if score / 1000 != level:
		level = score / 1000
		$Label2.text = "Level: " + str(level)
