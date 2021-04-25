extends KinematicBody2D

const SPEED = 100
const anguille_sound = preload("res://assets/sounds/br_anguille.wav")
const algue_sound = preload("res://assets/sounds/br_algues.wav")
const enemy_dead = preload("res://assets/sounds/br_ennemi_meurt.wav")

enum TYPE {SHOCK, SLOW, DEATH}

var velocity = Vector2.ZERO
var obs_type = TYPE.DEATH

func start(pos, vel):
	position = pos
	velocity = vel * SPEED
	$Sprite.flip_h = velocity.x > 0

func _physics_process(_delta):
	move_and_slide(velocity)

func destroy():
	MusicManager.play_sound(enemy_dead)
	queue_free()

func _on_Hurtbox_body_entered(player):
	if player.is_shielded:
		player.is_shielded = false
		destroy()
	elif !player.activated or player.is_dashing:
		destroy()
	else:
		match(obs_type):
			TYPE.SHOCK:
				player.is_shocked = true
				MusicManager.play_sound(anguille_sound)
			TYPE.SLOW:
				player.is_slowed = true
				MusicManager.play_sound(algue_sound)				
			TYPE.DEATH:
				player.loose()
		destroy()
			


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
