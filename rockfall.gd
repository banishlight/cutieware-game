extends AnimatableBody2D

var direction = Vector2.LEFT

var duration = 1
func _ready():
	start_tween()
	#constant_linear_velocity = direction * 75
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", Vector2(self.position.x-80, 190), duration)
	#delete after done.
	tween.bind_node(self)
