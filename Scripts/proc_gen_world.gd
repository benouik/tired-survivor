extends Node2D


@export var noise_height_text: NoiseTexture2D
@export var noise_tree_text: NoiseTexture2D
@export var player_scene: PackedScene
@export var feu_de_camp_scene: PackedScene

@export var fruit_scene: PackedScene

var noise: Noise
var tree_noise: Noise

var last_action = ""
var noise_values = []

@onready var tile_map :TileMap = $TileMap

var width :int = 200
var height :int = 200

var water_layer :int = 0
var ground_1_layer :int = 1
var ground_2_layer :int = 2
var cliff_layer :int = 3
var env_layer :int = 4
var cursor_layer: int = 5

var source_id :int = 0
var water_atlas :Vector2i = Vector2i(0, 1)
var land_atlas :Vector2i = Vector2i(0, 0)

var sand_tiles = []
var terrain_sand_int = 0

var grass_tiles = []
var terrain_grass_int = 1

var cliff_tiles = []
var terrain_cliff_int = 3

var old_cursor_pos = Vector2i()
var cursor_active :bool = false

var grass_atlas_arr = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0)]
var tree_atlas_arr = [Vector2i(12, 2), Vector2i(15, 2)]
var oak_tree_atlas = Vector2i(15, 6)
var cursor_atlas = Vector2i(0, 0)

var player_spawned: bool = false

var can_place_seeds_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"
var can_recolte_custom_data = "can_recolte"
var growing_custom_data = "growing"
var can_be_cut_custom_data = "can_be_cut"
enum FARMING_MODES {SEEDS, DIRT}

var farming_mode_state = FARMING_MODES.DIRT

var dirt_tiles = []

var campement_placed :bool = false

var damaged_trees = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	noise = noise_height_text.noise
	tree_noise = noise_tree_text.noise
	Global.set_interaction_ui_reference($CanvasLayer/InteractionUI, $CanvasLayer/InteractionLabel) 
	generate_world()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	source_id = 1
	#var atlas
	var mouse_pos :Vector2 = get_global_mouse_position()
	var tile_mouse_pos :Vector2i = tile_map.local_to_map(mouse_pos)
	
	var player_pos = $Player.position
	
	var tile_player_pos :Vector2i = tile_map.local_to_map(player_pos)
	
	if tile_mouse_pos.x >= tile_player_pos.x -1 and tile_mouse_pos.x <= tile_player_pos.x +1:
		if tile_mouse_pos.y >= tile_player_pos.y -1 and tile_mouse_pos.y <= tile_player_pos.y +1:
			cursor_active = true
		else:
			cursor_active = false
	else:
			cursor_active = false
	
	if tile_mouse_pos != old_cursor_pos:
		tile_map.erase_cell(cursor_layer, old_cursor_pos)
		
	if cursor_active:
		tile_map.set_cell(cursor_layer, tile_mouse_pos, source_id, cursor_atlas)
		#var can_dirt = check_ground_layer_custom_data(tile_mouse_pos, can_place_dirt_custom_data)
		
		#if int(delta) % 60 == 0:
			#print("Dirt: ", can_dirt)
			
		old_cursor_pos = tile_mouse_pos
		
	

func check_ground_layer_custom_data(tile_mouse_pos, custom_data):
	
	for layer in [ground_1_layer, ground_2_layer]:
		if retrieving_custom_data(tile_mouse_pos, custom_data, ground_1_layer) or retrieving_custom_data(tile_mouse_pos, custom_data, ground_2_layer):
			return true
	return false
		


func generate_world():
	noise.seed = RandomNumberGenerator.new().randf_range(0, 10000)
	
	for x in range(width):
		for y in range(height):
			noise_values.append(noise.get_noise_2d(x, y))
			
	var min_noise_value = noise_values.min()
	var max_noise_value = noise_values.max()
	var range_value = max_noise_value - min_noise_value
			
	for x in range(width):
		for y in range(height):
			var noise_val = (noise.get_noise_2d(x, y) - min_noise_value) / range_value
			var tree_noise_val = tree_noise.get_noise_2d(x, y)
			
			if noise_val >= 0.5:
				#print("Terre !")
				sand_tiles.append(Vector2i(x, y))
				if noise_val > 0.53 and noise_val < 0.62 and tree_noise_val > 0.75:
					tile_map.set_cell(env_layer, Vector2i(x, y), source_id, tree_atlas_arr.pick_random())
					
				if noise_val > 0.65:
					grass_tiles.append(Vector2i(x, y))
					if noise_val > 0.70:
						
						if noise_val < 0.72 and not player_spawned and x > width/4 and y > height/4:
							player_spawned = true
							var player = player_scene.instantiate()
							player.position = Vector2i(x*16, y*16)
							add_child(player)
							
						tile_map.set_cell(ground_2_layer, Vector2i(x, y), source_id, grass_atlas_arr.pick_random())
						
						if noise_val > 0.75 and noise_val < 0.85 and tree_noise_val > 0.75:
							tile_map.set_cell(env_layer, Vector2i(x, y), source_id, oak_tree_atlas)
							
						if noise_val > 0.9:
							cliff_tiles.append(Vector2i(x, y))
			
			tile_map.set_cell(0, Vector2i(x, y), source_id, water_atlas)
		
	tile_map.set_cells_terrain_connect(ground_1_layer, sand_tiles, terrain_sand_int, 0)
	tile_map.set_cells_terrain_connect(ground_1_layer, grass_tiles, terrain_grass_int, 0)
	tile_map.set_cells_terrain_connect(cliff_layer, cliff_tiles, terrain_cliff_int, 0)
	
	
func _input(_event):
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.DIRT
		#print("dirt")
	if Input.is_action_just_pressed("toggle_seeds"):
		#print("seeds")
		farming_mode_state = FARMING_MODES.SEEDS
		
	if Input.is_action_just_released("click"):
		last_action = ""
		print("none")
		
	if Input.is_action_pressed("click") and cursor_active:
		

		
		var mouse_pos :Vector2 = get_global_mouse_position()
		var tile_mouse_pos :Vector2i = tile_map.local_to_map(mouse_pos)

		var env_present = tile_map.get_cell_tile_data(env_layer, tile_mouse_pos)
		
		if Global.item_to_pickup != Node2D and last_action == "":
			Global.item_to_pickup.pickup_item()
			last_action = "pick"
			
		elif env_present and retrieving_custom_data(tile_mouse_pos, can_be_cut_custom_data, env_layer):
			if tile_mouse_pos in damaged_trees.keys():
				damaged_trees[tile_mouse_pos] -= 10
			else:
				damaged_trees[tile_mouse_pos] = 20
			if damaged_trees[tile_mouse_pos] <= 0:
				tile_map.erase_cell(env_layer, tile_mouse_pos)
				

		elif not campement_placed and not env_present:
			var feu_de_camp = feu_de_camp_scene.instantiate()
			feu_de_camp.position = Vector2(tile_mouse_pos.x *16-8, tile_mouse_pos.y *16-8)
			add_child(feu_de_camp)
			campement_placed = true
		
		elif not retrieving_custom_data(tile_mouse_pos, growing_custom_data, env_layer):
			
			if retrieving_custom_data(tile_mouse_pos, can_recolte_custom_data, env_layer):
				tile_map.erase_cell(env_layer, tile_mouse_pos)
				$Player.say("Miam !")
			
			
			
			elif farming_mode_state == FARMING_MODES.SEEDS and not env_present and Global.item_to_pickup == Node2D:
				if last_action == "seeds" or last_action == "":
					last_action = "seeds"
					print("seeds")
					
					var atlas_coord = Vector2i(11, 1)
					if retrieving_custom_data(tile_mouse_pos, can_place_seeds_custom_data, ground_1_layer):
						var level :int = 0
						var final_seed_level :int = 3
						handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level)
					
			elif farming_mode_state == FARMING_MODES.DIRT and not env_present and Global.item_to_pickup == Node2D:
				if last_action == "dirt" or last_action == "":
					last_action = "dirt"
					print("dirt")
					
					if retrieving_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_1_layer):
						dirt_tiles.append(tile_mouse_pos)
						tile_map.erase_cell(ground_2_layer, tile_mouse_pos)
						tile_map.set_cells_terrain_connect(ground_1_layer, dirt_tiles, 2, 0)
	#print("Max: ", noise_values.max(), "  Min: ", noise_values.min())
	
	
func retrieving_custom_data(tile_mouse_pos, custom_data_layer, layer):
	var tile_data :TileData = tile_map.get_cell_tile_data(layer, tile_mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false


func handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level):
	source_id = 0
	tile_map.set_cell(env_layer, tile_mouse_pos, source_id, atlas_coord)
	
	await get_tree().create_timer(1.0).timeout
	
	if level == final_seed_level -1:
		tile_map.erase_cell(env_layer, tile_mouse_pos)
		var fruit = fruit_scene.instantiate()
		fruit.position = Vector2(tile_mouse_pos.x *16+8, tile_mouse_pos.y *16+8)
		add_child(fruit)
		return
		
	else:
		var new_atlas :Vector2i = Vector2i(atlas_coord.x + 1, atlas_coord.y)
		tile_map.set_cell(env_layer, tile_mouse_pos, source_id, new_atlas)
		handle_seed(tile_mouse_pos, level +1, new_atlas, final_seed_level)	
		
		
#func normalize_array(array, min_value, max_value):
	#var new_array = []
	#var range_value = max_value - min_value
	#
	#for value in array:
		#new_array.append((value - min_value) / range_value)
		#
	#return new_array
