extends Node2D
class_name Room

@export var boss_room: bool = false
const SPAWN_SCENE: PackedScene = preload("res://Scenes/enemies/spawn_anim.tscn")
const ENEMY_SCENE: Dictionary = {
	"BAT": preload("res://Scenes/enemies/bat/bat.tscn"), 
	"ASSASSIN": preload("res://Scenes/enemies/assassin/assassin.tscn"),
	"SLIME": preload("res://Scenes/enemies/Boss/slime.tscn")
	}

var num_enemies: int

@onready var tilemap: TileMap = get_node("TileMap2")
@onready var entrance_cont: Node2D = get_node("Entrance")
@onready var doors_cont: Node2D = get_node("Doors")
@onready var enemy_pos_cont: Node2D = get_node("EnemyPos")
@onready var player_detector: Area2D = get_node("PlayerDetector")

func _ready() -> void:
	num_enemies = enemy_pos_cont.get_child_count()

func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()

func _open_doors() -> void:
	for door in doors_cont.get_children():
		door.open()
		
func _close() -> void:
	for entry_position in entrance_cont.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i(-1, 5), 3, Vector2i(2, 2))
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i(-1, 6), 3, Vector2i(6, 0))


func _spawn_enemies() -> void:
	for enemy_position in enemy_pos_cont.get_children():
		var enemy: CharacterBody2D 
		if boss_room:
			enemy = ENEMY_SCENE.SLIME.instantiate()
			num_enemies = 15
		else: 
			if randi() % 2 == 0:
				enemy = ENEMY_SCENE.BAT.instantiate()
			else:
				enemy = ENEMY_SCENE.ASSASSIN.instantiate()

		enemy.position = enemy_position.position 
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_SCENE.instantiate()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)

func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close()
		_spawn_enemies()
	else:
		_close()
		_open_doors()
