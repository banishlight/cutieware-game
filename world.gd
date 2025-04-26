extends Node2D

const WallObstacle = preload("res://obstacle.tscn")
const RockfallObstacle = preload("res://rockfall.tscn")
const FuelPickup = preload("res://fuel.tscn")


@onready var spawn_zone: ColorRect = $SpawnZone
@onready var deathPlane: Area2D = $DeathPlane
@onready var despawn_zone: Area2D = $DespawnZone
@onready var top_spawn: ColorRect = $TopSpawn

@onready var ship: CharacterBody2D = $Ship

@onready var obstacleTimer: Timer = $ObstacleTimer
@onready var fuelTimer: Timer = $FuelTimer

@onready var fuelLabel: Label = $FuelLabel
@onready var fuelCountLabel: Label = $FuelCountLabel
@onready var deathLabel: Label = $YouAreDead



func _ready():
	spawn_zone.hide()
	deathPlane.body_entered.connect(_check_if_dead)
	obstacleTimer.timeout.connect(_spawn_obstacle)
	Events.out_of_fuel.connect(_out_of_fuel)
	Events.updateFuel.connect(_update_fuel.bind())
	Events.add_fuel.connect(_add_fuel.bind())
	despawn_zone.body_entered.connect(_despawn_obstacle)
	fuelTimer.timeout.connect(_spawn_fuel)

func _check_if_dead(area: Node2D):
	if(area is CharacterBody2D):
		ship.queue_free()
		deathLabel.text = "YOU ARE DEAD"
	
func _spawn_obstacle():
	var num = randi() % 2
	print(num)
	if num == 0:
		spawn_wall()
	else:
		spawn_rockfall()
	
	
func spawn_wall():
	var wall = WallObstacle.instantiate()
	var rect = spawn_zone.get_global_rect()
	var wall_x = randf_range(rect.position.x, rect.end.x)
	##Walls should appear on screen, but can have the tops out of view.
	var wall_y = randf_range(rect.position.y-10, rect.end.y+10)
	wall.position = Vector2(wall_x, wall_y)
	add_child(wall)
	
func spawn_rockfall():
	var r_fall = RockfallObstacle.instantiate()
	var rect = top_spawn.get_global_rect()
	var r_fall_x = randf_range(rect.position.x, rect.end.x)
	##Walls should appear on screen, but can have the tops out of view.
	var r_fall_y = randf_range(rect.position.y-10, rect.end.y+10)
	r_fall.position = Vector2(r_fall_x, r_fall_y)
	add_child(r_fall)
	
func _spawn_fuel():
	var fuel = FuelPickup.instantiate()
	var rect = spawn_zone.get_global_rect()
	var fuel_x = randf_range(rect.position.x, rect.end.x)
	##Fuel should always fully appear on screen.
	## Note, numbers aren't right
	var fuel_y = randf_range(rect.position.y-20, rect.end.y+10)
	fuel.position = Vector2(fuel_x, fuel_y)
	add_child(fuel)
	
func _out_of_fuel():
	fuelLabel.text= "OUT OF FUEL"
	
func _despawn_obstacle(object: Node2D):
	object.queue_free()
	
func _update_fuel(count):
	fuelCountLabel.text = "Fuel: " + str(count)
	
func _add_fuel(amount: int):
	ship.currentFuel = ship.currentFuel+amount
