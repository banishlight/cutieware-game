extends CharacterBody2D

var SPEED = 100
var maxFuel = 1000
var currentFuel = maxFuel
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

## On physics tick...
func _physics_process(delta: float):
	var forward = false
	var back = false
	var fuelChange = -0.1
	velocity.y = 0
	if Input.is_action_pressed("ui_right"):
		forward = true
		if currentFuel >= 0:
			fuelChange -= .8
			velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		back = true
		velocity.x = -1 * SPEED *.7
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		if currentFuel >= 0:
			fuelChange -= 1
			velocity.y = -1 * SPEED *.5
			sprite.frame = 2
			
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED * 1.4
		sprite.frame = 1
	else:
		#slowly start dropping (glide)
		if (back):
			velocity.y = 30
		elif (!forward):
			velocity.y = 6
		fuelChange -= .1
		sprite.frame = 0
	if currentFuel==0:
		Events.out_of_fuel.emit()
	else:
		currentFuel = snapped(currentFuel+fuelChange, .1)
		
	
	Events.updateFuel.emit(currentFuel)
	move_and_slide()
	
