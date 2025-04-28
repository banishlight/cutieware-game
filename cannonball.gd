extends AnimatableBody2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var duration = 2
var direction = Vector2.LEFT

func _ready():
	hurtbox.body_entered.connect(_calculate_hit)
	sprite.play("default")
	start_tween()
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", Vector2(-40, self.position.y), duration)
	#delete after done.
	tween.bind_node(self)
	
func _calculate_hit(area: Node2D):
	if(area is CharacterBody2D):
		Events.take_damage.emit(1)
		queue_free()

	
