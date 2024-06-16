extends Room

const WEAPON_LIST: Array = [preload("res://Scenes/Weapons/wooden_hammer.tscn"), preload("res://Scenes/Weapons/axe.tscn")]

@onready var weapon_pos: Marker2D = get_node("WeaponPos")

func _ready():
	var weapon: Node2D = WEAPON_LIST[randi() % WEAPON_LIST.size()].instantiate()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon)
