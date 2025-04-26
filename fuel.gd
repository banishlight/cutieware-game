extends Sprite2D

@onready var pickupBox: Area2D = $Area2D
var duration = 8
var direction = Vector2.LEFT
func _ready():
	start_tween()
	pickupBox.body_entered.connect(_pickup_check)
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", Vector2(-40, self.position.y), duration)

func _pickup_check(area: Node2D):
	if(area is CharacterBody2D):
		Events.add_fuel.emit(500)
		queue_free()
	
	
