@icon("res://Assets/players/idle_anim/player_idle1.png")

extends CharacterBody2D
class_name Character

const FRICTION: float = 0.15

@export var max_hp: int = 2
@export var hp: int = 2: set = set_hp
@export var accerelation: int = 40
@export var max_speed: int = 100
@export var fly: bool = false

signal hp_changed(new_hp)

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var state_machine: Node = get_node("FiniteStateMachine")


var mov_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)


func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * accerelation
	velocity = velocity.limit_length(max_speed)

func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		self.hp -= dam
		if name == "Player":
			SavedData.hp = self.hp
			if hp == 0:
				SceneTransistor.start_transition_to("res://Scenes/game/game.tscn")
				SavedData.reset_data()
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
		if hp <= 0:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2
			
	
func set_hp(new_hp: int) -> void:
	hp = clamp(new_hp, 0, max_hp)
	emit_signal("hp_changed", hp)

