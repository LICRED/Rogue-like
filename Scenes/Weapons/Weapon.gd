@icon("res://Assets/items/weapons/weapon_sword.png")

extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var hitbox: Area2D = get_node("Node2D/Sprite2D/Hitbox")
@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var cooldown_timer: Timer = get_node("CooldownTimer")
@onready var ui: CanvasLayer = get_node("UI")
@export var on_floor: bool = false

var tween: Tween
var can_strong_attack: bool = true

func _ready() -> void:
	cooldown_timer.start()
	if not on_floor:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)

func get_input() -> void:
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")
	elif Input.is_action_just_pressed("strong_attack") and can_strong_attack:
		cooldown_timer.start()
		ui.recharge_anim(cooldown_timer.wait_time)
		can_strong_attack = false
		animation_player.play("strong_attack")

func move(mouse_direction: Vector2) -> void:
	if not animation_player.is_playing():
		rotation = mouse_direction.angle()
		hitbox.knockback_direction = mouse_direction
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1

func _on_player_detector_body_entered(body: CharacterBody2D) -> void:
	if body != null:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		tween.stop()
		player_detector.set_collision_mask_value(1, true)

func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	position = initial_pos
	tween = create_tween()
	tween.tween_property(self, "position", final_pos, 0.3)
	tween.play()
	player_detector.set_collision_mask_value(1, true)
	await tween.finished
	player_detector.set_collision_mask_value(2, true)

func _on_cooldown_timer_timeout():
	can_strong_attack = true

