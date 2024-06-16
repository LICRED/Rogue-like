extends Node2D


const SPAWN_ROOMS: Array = [preload("res://Scenes/Rooms/Spawn_Room/spawn_room_0.tscn"), preload("res://Scenes/Rooms/Spawn_Room/spawn_room_1.tscn")]
const MIDDLE_ROOMS: Array = [preload("res://Scenes/Rooms/Room/room_0.tscn"), preload("res://Scenes/Rooms/Room/room_1.tscn"), preload("res://Scenes/Rooms/Room/room_2.tscn"), preload("res://Scenes/Rooms/Room/room_3.tscn"), preload("res://Scenes/Rooms/Room/room_4.tscn")]
const END_ROOMS: Array = [preload("res://Scenes/Rooms/End_Room/end_room_0.tscn")]
const BOSS_ROOMS: Array = [preload("res://Scenes/Rooms/Boss_Room/boss_room_0.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_POS = Vector2i(0, 3)
const LEFT_WALL_TILE_POS = Vector2i(4, 1)
const RIGHT_WALL_TILE_POS = Vector2i(3, 1)

@export var num_levels: int = randi_range(5, 7)

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	SavedData.floor_num += 1
	if SavedData.floor_num == 3:
		num_levels = 3
	_spawn_rooms()


func _spawn_rooms() -> void:
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("SpawnPos").global_position
			
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				if SavedData.floor_num == 3:
					room = BOSS_ROOMS[randi() % BOSS_ROOMS.size()].instantiate()
					SavedData.floor_num = 0
				else:
					room = MIDDLE_ROOMS[randi() % MIDDLE_ROOMS.size()].instantiate()
			
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_door.position) + Vector2i(-1, 3)
			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y), 3, LEFT_WALL_TILE_POS)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y), 3, FLOOR_TILE_POS)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y), 3, FLOOR_TILE_POS)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y), 3, RIGHT_WALL_TILE_POS)

			var room_tilemap: TileMap = room.get_node("TileMap")
			room.position = previous_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Marker2D2").position).x * TILE_SIZE - Vector2(5, -74)

		add_child(room)
		previous_room = room

