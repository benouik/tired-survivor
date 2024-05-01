extends RayCast2D


signal see(pos, collide)

var target: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if is_colliding():
		target = get_collision_point()
#		print(target)
		see.emit(target, true)
	else:
		target = to_global(target_position)
#		print(target)
		see.emit(target, false)
