extends CanvasLayer

const MIN_HEALTH: int = 18
var max_hp: int = 4

@onready var player: CharacterBody2D = get_parent().get_node("Player")
@onready var health_bar: TextureProgressBar = get_node("HealthBar")


func _ready() -> void:
	self.max_hp = player.max_hp
	_update_health_bar(100)


func _update_health_bar(new_value: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", new_value, 0.1)

func _on_player_hp_changed(new_hp) -> void:
	var new_health: int = int((100 - MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	_update_health_bar(new_health)
