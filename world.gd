extends Node2D

const WallObstacle = preload("res://obstacle.tscn")
const RockfallObstacle = preload("res://telegraph.tscn")
const FuelPickup = preload("res://fuel.tscn")
const CannonballObstacle = preload("res://cannonball.tscn")
const RepairPickup = preload("res://repair.tscn")


@onready var spawn_zone: ColorRect = $SpawnZone
@onready var deathPlane: Area2D = $DeathPlane
@onready var despawn_zone: Area2D = $DespawnZone
@onready var top_spawn: ColorRect = $TopSpawn

@onready var ship: CharacterBody2D = $Ship

@onready var obstacleTimer: Timer = $ObstacleTimer
@onready var rockTimer: Timer = $RockTimer
@onready var fuelTimer: Timer = $FuelTimer
@onready var cannonballTimer: Timer = $CannonballTimer
@onready var repairTimer: Timer =  $RepairTimer

@onready var fuelLabel: Label = $FuelLabel
@onready var fuelCountLabel: Label = $FuelCountLabel
@onready var deathLabel: Label = $YouAreDead
@onready var distanceLabel: Label = $Label/DistanceLabel
@onready var hpBar: CanvasLayer = $HPBar
var metersTravelled = 0
var difficulty = 1
var gameOver = false

func _ready():
	spawn_zone.hide()
	#Zone checks
	deathPlane.body_entered.connect(_check_if_dead)
	despawn_zone.body_entered.connect(_despawn_obstacle)

	#Fuel checks
	Events.out_of_fuel.connect(_out_of_fuel)
	Events.updateFuel.connect(_update_fuel.bind())
	Events.add_fuel.connect(_add_fuel.bind())
	
	#Timers
	fuelTimer.timeout.connect(_spawn_powerup.bind("fuel"))
	repairTimer.timeout.connect(_spawn_powerup.bind("repair"))
	obstacleTimer.timeout.connect(_spawn_wall)
	rockTimer.timeout.connect(_spawn_rockfall)
	cannonballTimer.timeout.connect(_spawn_cannonball)
	
	Events.zero_hp.connect(_die_and_game_over)

func _process(_delta: float):
	metersTravelled = metersTravelled+1
	distanceLabel.text=str(metersTravelled)
	## increase spawn timers at every 1000 meters, to add challenge.
	if !gameOver:
		if(metersTravelled> (difficulty*1000) && difficulty < 8):
			obstacleTimer.wait_time = obstacleTimer.wait_time - (obstacleTimer.wait_time*.06)
			rockTimer.wait_time = rockTimer.wait_time - (rockTimer.wait_time*.10)
			cannonballTimer.wait_time = cannonballTimer.wait_time - (cannonballTimer.wait_time*.15)
			difficulty = difficulty+1
			#print('difficulty: ', difficulty)
			#print('cannonball timer: ', cannonballTimer.wait_time)
			#print('rock timer: ', rockTimer.wait_time)
			#print('obstacle timer: ', obstacleTimer.wait_time)
		elif(metersTravelled> (difficulty*1000) && (difficulty < 20 && difficulty >= 8)):
			obstacleTimer.wait_time = obstacleTimer.wait_time - (obstacleTimer.wait_time*.02)
			rockTimer.wait_time = rockTimer.wait_time - (rockTimer.wait_time*.05)
			cannonballTimer.wait_time = cannonballTimer.wait_time - (cannonballTimer.wait_time*.08)
			difficulty = difficulty+1
			#print('difficulty: ', difficulty)
			#print('cannonball timer: ', cannonballTimer.wait_time)
			#print('rock timer: ', rockTimer.wait_time)
			#print('obstacle timer: ', obstacleTimer.wait_time)
	

func _check_if_dead(area: Node2D):
	if(area is CharacterBody2D):
		_die_and_game_over()
		
func _die_and_game_over():
	ship.queue_free()
	gameOver = true
	deathLabel.text = "YOU ARE DEAD"
	
func _spawn_wall():
	var wall = WallObstacle.instantiate()
	var rect = spawn_zone.get_global_rect()
	var wall_x = randf_range(rect.position.x, rect.end.x)
	##Walls should appear on screen, but can have the tops and bottoms out of view.
	var wall_y = randf_range(rect.position.y-10, rect.end.y+10)
	wall.position = Vector2(wall_x, wall_y)
	add_child(wall)
	
func _spawn_rockfall():
	var r_fall = RockfallObstacle.instantiate()
	var rect = top_spawn.get_global_rect()
	var r_fall_x = randf_range(rect.position.x+10, rect.end.x-10)
	##Telegraphs should be at the ceiling of the playfield.
	r_fall.position = Vector2(r_fall_x, 10)
	add_child(r_fall)
	
func _spawn_cannonball():
	var cannonball = CannonballObstacle.instantiate()
	var rect = spawn_zone.get_global_rect()
	var cannonball_x = randf_range(rect.position.x, rect.end.x)
	##Cannonballs have to appear fully on screen.
	var cannonball_y = randf_range(rect.position.y+16, rect.end.y-16)
	cannonball.position = Vector2(cannonball_x, cannonball_y)
	add_child(cannonball)
	
func _spawn_powerup(powerup_name: String):
	var powerup
	match powerup_name:
		"fuel":
			powerup = FuelPickup.instantiate()
		"repair":
			powerup = RepairPickup.instantiate()

	var rect = spawn_zone.get_global_rect()
	var powerup_x = randf_range(rect.position.x, rect.end.x)
	##Powerups should always fully appear on screen.
	var powerup_y = randf_range(rect.position.y+20, rect.end.y+10)
	powerup.position = Vector2(powerup_x, powerup_y)
	add_child(powerup)
	
func _out_of_fuel():
	fuelLabel.text= "OUT OF FUEL"
	
func _despawn_obstacle(object: Node2D):
	object.queue_free()
	
func _update_fuel(count):
	fuelCountLabel.text = "Fuel: " + str(count)
	
func _add_fuel(amount: int):
	ship.currentFuel = ship.currentFuel+amount

	
	
