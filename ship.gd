extends CharacterBody2D

var SPEED = 100
var maxFuel = 1000
var currentFuel = 1000
var dodging = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dodgeTimer: Timer = $DodgeTimer

@onready var collision: CollisionShape2D = $Collision
@onready var deathCollision: CollisionShape2D = $DeathCheckBox/DeathCollision

func _ready():
	dodgeTimer.timeout.connect(_recover_from_dodge)
	

## On physics tick...
func _physics_process(delta: float):
	var forward = false
	var back = false
	var fuelChange = -0.1
	velocity.y = 0
	
	if dodging:
		fuelChange -= 2
	elif Input.is_action_pressed("plane_dodge") and currentFuel > 50:
		velocity.x = SPEED * .8
		#hold altitude
		velocity.y = 0
		dodging = true
		sprite.frame = 3
		dodgeTimer.start()
		collision.disabled=true
		deathCollision.disabled=true
		sprite.z_index=10
	else:
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
	
	if currentFuel<=0:
		Events.out_of_fuel.emit()
	else:
		currentFuel = snapped(currentFuel+fuelChange, .1)
		
		
	
	Events.updateFuel.emit(currentFuel)
	move_and_slide()
	
func _recover_from_dodge():
	print("tick!")
	dodging = false
	sprite.frame=0
	collision.disabled=false
	deathCollision.disabled=false
	sprite.z_index=0
