extends Hitbox

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	animation_player.play("attack")

func _collide(body: Node2D) -> void:
	if not body.fly and body.has_method("take_damage"):
		knockback_direction = (body.global_position - global_position).normalized()
		body.take_damage(damage, knockback_direction, knockback_force)
