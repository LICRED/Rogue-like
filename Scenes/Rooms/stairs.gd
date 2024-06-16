extends Area2D

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

func _on_body_entered(_body: CharacterBody2D) -> void:
	collision_shape.disabled = true
	SceneTransistor.start_transition_to("res://Scenes/game/game.tscn")
