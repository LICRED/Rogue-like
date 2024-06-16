@icon("res://Assets/Characters/idle_anim/player_idle1.png")

extends Character

var current_weapon: Node2D
enum {UP, DOWN}


@onready var weapons: Node2D = get_node("Weapons")

func _ready() -> void:
	_restore_previous_state()

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	current_weapon.move(mouse_direction)

func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("up"):
		mov_direction += Vector2.UP
	if Input.is_action_just_pressed("scroll_up"):
		print(1)
		_switch_weapon(UP)
	if Input.is_action_just_pressed("scroll_down"):
		_switch_weapon(DOWN)
	if Input.is_action_pressed("drop") and current_weapon.get_index() != 0:
		_drop_weapon()
	
	current_weapon.get_input()

func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.enabled = true
	get_node("Camera2D").enabled = false

func _restore_previous_state() -> void:
	self.hp = SavedData.hp
	for weapon in SavedData.weapon:
		weapon = weapon.duplicate()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)
		weapon.hide()
	
	current_weapon = weapons.get_child(SavedData.current_weapon_index)
	current_weapon.show()

func _switch_weapon(direction: int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if direction == DOWN:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0

	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	SavedData.current_weapon_index = index

func pick_up_weapon(weapon: Node2D) -> void:
	SavedData.weapon.append(weapon.duplicate())
	SavedData.current_weapon_index = weapons.get_child_count()
	
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon = weapon

func _drop_weapon() -> void:
	SavedData.weapons.remove_at(current_weapon.get_index() - 1)
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(DOWN)

	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	await weapon_to_drop.tree_entered
	weapon_to_drop.show()

	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
