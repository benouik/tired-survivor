extends Node2D


@onready var tile_map :TileMap = $TileMap

var ground_layer_int = 1
var env_layer_int = 2
var can_place_seeds_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"

enum FARMING_MODES {SEEDS, DIRT}

var farming_mode_state = FARMING_MODES.DIRT

var dirt_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.DIRT
		print("dirt")
	if Input.is_action_just_pressed("toggle_seeds"):
		print("seeds")
		farming_mode_state = FARMING_MODES.SEEDS
		
	if Input.is_action_just_pressed("click"):
		
		var mouse_pos :Vector2 = get_global_mouse_position()
		var tile_mouse_pos :Vector2i = tile_map.local_to_map(mouse_pos)
		
		
		if farming_mode_state == FARMING_MODES.SEEDS:
			var atlas_coord = Vector2i(11, 1)
			if retrieving_custom_data(tile_mouse_pos, can_place_seeds_custom_data, ground_layer_int):
				var level :int = 0
				var final_seed_level :int = 3
				handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level)
				
		if farming_mode_state == FARMING_MODES.DIRT:
			if retrieving_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer_int):
				dirt_tiles.append(tile_mouse_pos)
				tile_map.set_cells_terrain_connect(ground_layer_int, dirt_tiles, 2, 0)
				
		


func retrieving_custom_data(tile_mouse_pos, custom_data_layer, layer):
	var tile_data :TileData = tile_map.get_cell_tile_data(layer, tile_mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false
		

func handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level):
	var source_id :int = 0
	tile_map.set_cell(env_layer_int, tile_mouse_pos, source_id, atlas_coord)
	
	await get_tree().create_timer(5.0).timeout
	
	if level == final_seed_level:
		return
		
	else:
		var new_atlas :Vector2i = Vector2i(atlas_coord.x + 1, atlas_coord.y)
		tile_map.set_cell(env_layer_int, tile_mouse_pos, source_id, new_atlas)
		handle_seed(tile_mouse_pos, level +1, new_atlas, final_seed_level)
