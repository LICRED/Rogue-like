extends Enemy

const KNIFE_SCENE: PackedScene = preload("res://Scenes/enemies/assassin/assassin_knife.tscn")

const MAX_DISTANCE: int = 80
const MIN_DISTANCE: int = 40

var distance_player: float
var can_attack: bool = true

@export var projectile_speed: int = 150
@onready var cooldown_timer: Timer = get_node("CooldownTimer")
@onready var raycast: RayCast2D = get_node("RayCast2D")

func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		distance_player = (player.global_position - global_position).length()
		if distance_player > MAX_DISTANCE:
			_get_path_to_player()
		elif distance_player < MIN_DISTANCE:
			_get_path_from_player()
		else:
			raycast.target_position = player.position - global_position
			if can_attack and state_machine.state == state_machine.states.idle and not raycast.is_colliding():
				can_attack = false
				_throw_knife()
				cooldown_timer.start()
	else:
		path_timer.stop()
		mov_direction = Vector2.ZERO

func _throw_knife() -> void:
	var projectile: Area2D = KNIFE_SCENE.instantiate()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _get_path_from_player() -> void:
	var dir: Vector2 = (position - player.position).normalized()
	navigation_agent.target_position = global_position + dir * 100

func _on_cooldown_timer_timeout() -> void:
	can_attack = true
