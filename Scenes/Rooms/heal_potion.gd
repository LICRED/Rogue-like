extends Area2D
@onready var tween: Tween

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

func _on_body_entered(body: CharacterBody2D):
	collision_shape.disabled = true
	body.hp += 1
	SavedData.hp += 1
	tween.property(sprite, "modulate:a", 0, 0.5)
	tween.play()
	await tween.finished
	queue_free()
