extends CanvasLayer

@onready var icon: TextureProgressBar = get_node("TextureProgressBar")

func recharge_anim(time: float) -> void:
	icon.value = 100
	var tween = create_tween()
	tween.tween_property(icon, "value", 0, time)
