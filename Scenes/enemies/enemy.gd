@icon("res://Assets/enemies/knight/idle_anim/knight_idle_anim1.png")

extends Character
class_name Enemy

@onready var path_timer: Timer = get_node("PathTimer")
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

func _ready() -> void:
	connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))

func chase() -> void:
	if not navigation_agent.is_target_reached():
		var vector_to_next_point: Vector2 = navigation_agent.get_next_path_position() - global_position
		mov_direction = vector_to_next_point

		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true

func _get_path_to_player() -> void:
	navigation_agent.target_position = player.position

func _on_path_timer_timeout():
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		mov_direction = Vector2.ZERO
