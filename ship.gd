extends CharacterBody2D


##func _ready():

var SPEED = 50

## On physics tick...
func _physics_process(delta: float):
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1 * SPEED
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1 * SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	else:
		#slowly start dropping (glide)
		velocity.y = 6
		
	move_and_slide()
	
