extends Node2D

const WallObstacle = preload("res://obstacle.tscn")
const FuelPickup = preload("res://fuel.tscn")

@onready var deathPlane: Area2D = $DeathPlane
@onready var ship: CharacterBody2D = $Ship
@onready var deathLabel: Label = $YouAreDead
@onready var spawn_zone: ColorRect = $SpawnZone
@onready var obstacleTimer: Timer = $ObstacleTimer
@onready var fuelTimer: Timer = $FuelTimer
@onready var fuelLabel: Label = $FuelLabel
@onready var fuelCountLabel: Label = $FuelCountLabel
@onready var despawn_zone: Area2D = $DespawnZone


func _ready():
	spawn_zone.hide()
	deathPlane.area_entered.connect(_check_if_dead)
	obstacleTimer.timeout.connect(_spawn_obstacle)
	Events.out_of_fuel.connect(_out_of_fuel)
	Events.updateFuel.connect(_update_fuel.bind())
	Events.add_fuel.connect(_add_fuel.bind())
	despawn_zone.body_entered.connect(_despawn_obstacle)
	fuelTimer.timeout.connect(_spawn_fuel)

func _check_if_dead(area: Area2D):
	## don't even bother worrying about enemy deathboxes
	ship.queue_free()
	deathLabel.text = "YOU ARE DEAD"
	
func _spawn_obstacle():
	var wall = WallObstacle.instantiate()
	var rect = spawn_zone.get_global_rect()
	var wall_x = randf_range(rect.position.x, rect.end.x)
	##Walls should appear on screen, but can have the tops out of view.
	var wall_y = randf_range(rect.position.y-10, rect.end.y+10)
	wall.position = Vector2(wall_x, wall_y)
	add_child(wall)
	
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
