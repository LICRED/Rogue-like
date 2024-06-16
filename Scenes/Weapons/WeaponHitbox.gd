extends Hitbox

func _on_area_entered(area):
	area.queue_free()
