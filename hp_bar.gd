extends Node2D
## Incredibly dirty, figure out better way later
@onready var hp_1: ColorRect = $HP1
@onready var hp_2: ColorRect = $HP2
@onready var hp_3: ColorRect = $HP3
@onready var hp_4: ColorRect = $HP4
@onready var hp_5: ColorRect = $HP5

var MAX_HP = 5
var hp: int
var hp_array = []

func _ready():
	hp = MAX_HP
	hp_array = [hp_1, hp_2, hp_3, hp_4, hp_5]
	
	Events.take_damage.connect(_take_damage.bind())
	Events.heal_hp.connect(_heal_hp.bind())
	

func _take_damage(damage: int):
	var damage_taken = damage
	while damage_taken > 0 and hp > 0:
		hp -= 1
		hp_array[hp].set_color("#ff0000")
		damage_taken -=1
		if hp == 0:
			Events.zero_hp.emit()
			break
			
func _heal_hp(amount: int):
	var amount_healed = amount
	while amount_healed > 0 and hp < MAX_HP:
		hp_array[hp].set_color("#00ff2f")
		hp += 1
		amount_healed -=1
