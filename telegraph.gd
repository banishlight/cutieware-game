extends AnimatedSprite2D

const RockfallObstacle = preload("res://rockfall.tscn")

@onready var obstacleTimer: Timer = $SpawnTimer

func _ready():
	self.play("default")
	obstacleTimer.timeout.connect(_spawn_rockfall)
	
func _spawn_rockfall():
	var r_fall = RockfallObstacle.instantiate()
	r_fall.position = Vector2(self.position.x, self.position.y-20)
	add_sibling(r_fall)
	queue_free()
	
