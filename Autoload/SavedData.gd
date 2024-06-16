extends Node

var floor_num: int = 0
var hp: int = 4
var weapon: Array = []
var current_weapon_index: int = 0 

func reset_data() -> void:
	floor_num = 0
	hp = 4
	weapon = []
	current_weapon_index = 0
