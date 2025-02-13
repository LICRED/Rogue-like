extends CanvasLayer

var new_scene: String

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func start_transition_to(path_to_scene: String) -> void:
	new_scene = path_to_scene
	animation_player.play("change_scene")
	
	
func change_scene() -> void:
	get_tree().change_scene_to_file(new_scene)


