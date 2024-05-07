extends CharacterBody2D

var speed:int = 120
var animDirection = "Down"
var dead = false

var can_be_hit: bool = true
var health: int = 3

var nrj: float = 60.0

var aim_pos: Vector2

var sur_batterie:bool = false

var on_grass: bool
var tile_pos: Vector2i

#@onready var interaction_ui = $InteractionUI
@onready var animations = $AnimationPlayer
@onready var inventory_ui = $InventoryUI
@onready var hotbar = $Hotbar

signal coin(pos, dir)
signal grenade(pos, dir, vel)
signal etrangler()

var max_zoom :float = 3.0
var min_zoom :float = 0.5

func cast_ray(start, target):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(start, target)
	query.set_collision_mask(1 | 11)
	query.exclude = [self]
#	query.collide_with_areas = true
	
	return space_state.intersect_ray(query)

func death():
	animations.stop()
	$Sprite2D.hide()
	$Death.show()
	animations.play("Explosion")
	$TextBox/Label.text = "Chui mort"
#		$Sprite2D.rotation_degrees = 90
#		animations.stop()
	$TextBox/Label.show()
	$TimerDeath.start()
	dead = true

func say(text):
	$TextBox/Label.text = text
	$TextBox/Label.show()
	$TimerLabel.start()

func hit():
	if not dead and can_be_hit:
		health -= 1
		if health <= 0:
			animations.stop()
			$Sprite2D.hide()
			$Death.show()
			animations.play("Explosion")
			$TextBox/Label.text = "Chui mort"
#		$Sprite2D.rotation_degrees = 90
#		animations.stop()
			$TextBox/Label.show()
			$TimerDeath.start()
			dead = true
		else:
			can_be_hit = false
			$TimerHitCooldown.start()
		
			$TextBox/Label.text = "Aie"
			$TextBox/Label.show()
			$TimerLabel.start()
			
		var tween = get_tree().create_tween()
#		tween.set_parallel(true)
#		var shader_color = $Sprite2D.material.get_shader_parameter("hit_color")

		for i in range(5):
			tween.tween_property($Sprite2D, "skew", 0, 0.02)
			tween.tween_property($Sprite2D, "skew", 0, 0.02)
			tween.tween_property($Sprite2D, "skew", 0.15, 0.02)
			tween.tween_property($Sprite2D, "skew", 0, 0.02)
			tween.tween_property($Sprite2D, "skew", -0.15, 0.02)
			tween.tween_property($Sprite2D, "skew", 0, 0.02)
			
		var tween2 = get_tree().create_tween()	
		var tween3 = get_tree().create_tween()		
		for i in range(5):


			tween2.tween_method(set_shader_color, 1.0, 0.2, 0.04)
			tween2.tween_method(set_shader_color, 0.2, 1.0, 0.04)
			
			tween3.tween_method(set_shader_intensity, 0.0, 0.2, 0.02)
			tween3.tween_method(set_shader_intensity, 0.2, 0.7, 0.02) # args are: (method to call / start value / end value / duration of animation)
			tween3.tween_method(set_shader_intensity, 0.7, 0.2, 0.02)
			tween3.tween_method(set_shader_intensity, 0.2, 0.0, 0.02)
			
			tween.tween_property($Sprite2D, "skew", 0, 0.02)

func set_shader_color(value: float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	$Sprite2D.material.set_shader_parameter("changing_color", value)

	
func set_shader_intensity(value: float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	$Sprite2D.material.set_shader_parameter("intensity", value)

func _ready():
	
	# Set this node as the Player node
	Global.set_player_reference(self)
	check_ground()
	
# Regarde quel type de sol sous le joueur.
func check_ground():
	
	# Les coordonnées de la Tile sur laquelle le joueur se trouve
	tile_pos = Global.tile_map.local_to_map(position)
	
	# On vérifie si il y a une Tile sur le Grass Layer 
	var data = Global.tile_map.get_cell_tile_data(3, tile_pos)
	
	if data:
		on_grass = true
	else:
		on_grass = false



func updateAnimation():
	
	
	var mode = ""
	if velocity.x == 0 and velocity.y == 0:
		mode = "idle"
	else:
		mode = "walk"
	
	if velocity.x == 0 and velocity.y == 0:
		pass
	else:
		var view_angle = int(rad_to_deg(velocity.angle()))
		
		if view_angle > 45 and view_angle < 135:
			animDirection = "Down"
		if view_angle >= 135 or view_angle < -135:
			animDirection = "Left"
		if view_angle >= -135 and view_angle < -45:
			animDirection = "Up"
		if view_angle >= -45 and view_angle <= 45:
			animDirection = "Right"		

	animations.play(mode + animDirection)

#func _draw():
#	draw_line(Vector2.ZERO, aim_pos, Color(1, 1, 1, 1))


func _input(_event):
	
	
	if Input.is_action_just_pressed("zoom_in"):
		Global.item_in_hand = min(Global.item_in_hand +1, Global.hotbar.size())
		print(Global.item_in_hand)
	if Input.is_action_just_pressed("zoom_out"):
		Global.item_in_hand = max(Global.item_in_hand -1, 0)
		print(Global.item_in_hand)
		
		
	var item_in_hand = 1
	
	#if Input.is_action_just_pressed("zoom_in"):
		#var zoom_val = min($Camera2D.zoom.x + 0.1, max_zoom)
		#$Camera2D.zoom = Vector2(zoom_val, zoom_val)
	#if Input.is_action_just_pressed("zoom_out"):
		#var zoom_val = max($Camera2D.zoom.x - 0.1, min_zoom)
		#$Camera2D.zoom = Vector2(zoom_val, zoom_val)
		
	if Input.is_action_just_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		hotbar.visible = !hotbar.visible
		get_tree().paused = !get_tree().paused
		
		
func _process(_delta):
	
	$TextBox.offset = global_position
	if not dead:

		var current_speed: int
		
		check_ground()
		
		if not on_grass:
			current_speed = speed - 30
		else:
			current_speed = speed

		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * current_speed
		updateAnimation()
		move_and_slide()


func _on_timer_death_timeout():
#	print("reload")
	get_tree().reload_current_scene()


func _on_timer_label_timeout():
	$TextBox/Label.hide()


func _on_timer_hit_cooldown_timeout():
	self.death()


func _on_ray_cast_2d_see(pos, collide):
	aim_pos = pos
	$Line2D.points = [Vector2.ZERO, to_local(pos)]

	if collide and (Input.is_action_pressed("SecondaryAction") or Input.is_action_pressed("PrimaryAction")):
		$Polygon2D.global_position = pos
		$Polygon2D.show()
	else:
		$Polygon2D.hide()

func _on_home_area_entered(_area):
	print("Revenu")
	$TimerFatigue.stop()
	$TextBox/Label.hide()
	
func _on_home_area_exited(_area):
	print("Sorti")
	$TimerFatigue.wait_time = nrj
	sur_batterie = true


func _on_home_body_entered(_body):
	print("Revenu")
	sur_batterie = false
	$TimerFatigue.stop()
	$"../../CanvasLayer2/ProgressBar".value = 100
	nrj += 5
	$"../../CanvasLayer2/Control/Label".text = str(nrj)


func _on_home_body_exited(_body):
	print("Sorti")
	$TimerFatigue.wait_time = nrj
	$TimerFatigue.start()
	sur_batterie = true
