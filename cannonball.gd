extends AnimatableBody2D
var direction = Vector2.LEFT

var duration = 3
func _ready():
	start_tween()
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", Vector2(-40, self.position.y), duration)
	#delete after done.
	tween.bind_node(self)
