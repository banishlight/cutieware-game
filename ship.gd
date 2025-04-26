extends CharacterBody2D

var SPEED = 50
var maxFuel = 100
var currentFuel = maxFuel

## On physics tick...
func _physics_process(delta: float):
	if Input.is_action_pressed("ui_right"):
		if currentFuel >= 0:
			currentFuel -= 1
			velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1 * SPEED
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		if currentFuel >= 0:
			currentFuel -= 1
			velocity.y = -1 * SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	else:
		#slowly start dropping (glide)
		velocity.y = 6
	
	if currentFuel==0:
		Events.out_of_fuel.emit()
	
	move_and_slide()
	
