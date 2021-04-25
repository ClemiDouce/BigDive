extends KinematicBody2D

const SPEED = 100

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
	queue_free()

func _on_Hurtbox_body_entered(player):
	match(obs_type):
		TYPE.SHOCK:
			player.is_shocked = true
			self.destroy()
		TYPE.SLOW:
			player.is_slowed = true
			self.destroy()
		TYPE.DEATH:
			if player.is_shielded:
				self.destroy()
				player.is_shielded = false
			else:
				player.loose()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
