extends CharacterBody2D

var SPEED = 50
var maxFuel = 1000
var currentFuel = maxFuel
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

## On physics tick...
func _physics_process(delta: float):
	var forward = false
	velocity.y = 0
	if Input.is_action_pressed("ui_right"):
		forward = true
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
			sprite.frame = 2
			
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
		sprite.frame = 1
	else:
		#slowly start dropping (glide)
		if (!forward):
			velocity.y = 6
		sprite.frame = 0
	
	if currentFuel==0:
		Events.out_of_fuel.emit()
	Events.updateFuel.emit(currentFuel)
	move_and_slide()
	
