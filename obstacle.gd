extends AnimatableBody2D
var direction = Vector2.LEFT

var duration = 5
func _ready():
	start_tween()
	#constant_linear_velocity = direction * 75
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", Vector2.LEFT, duration)
	##tween.tween_property(self, "position", Vector2(-40,0), duration)
