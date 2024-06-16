extends FiniteStateMachine

@onready var move_timer: Timer = $"../MoveTimer"
@onready var path_timer: Timer = $"../PathTimer"
@onready var hitbox: Area2D = $"../Hitbox"

var can_move: bool = false

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")

func _ready():
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()

func _get_transition() -> int:
	match state:
		states.idle:
			if can_move:
				can_move = false
				return states.move
		states.move:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			path_timer.stop()
			hitbox.knockback_direction = (parent.navigation_agent.get_next_path_position() - parent.global_position).normalized() * 2
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")

func _exit_state(state_exited: int) -> void:
	if state_exited == states.move:
		can_move = false
		move_timer.start()
		path_timer.start()

func _on_move_timer_timeout():
	can_move = true
