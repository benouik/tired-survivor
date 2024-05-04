### Global.gd

extends Node

# Scene and node references
var player_node: Node = null
var interaction_ui: ColorRect = null
var interaction_label: Label = null

var cursor_active: bool = false
var tile_map: TileMap
# Inventory items
var inventory = []
var can_plante: bool = true
# Custom signals
signal inventory_updated

var item_to_pickup = Node2D
var world: Node2D

var tool_on_hand = null

@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")


func _ready(): 
	# Initializes the inventory with 30 slots (spread over 9 blocks per row)
	inventory.resize(30)
	
	
func remove_seed_tile_at_cursor():
	var mouse_pos :Vector2 = world.get_global_mouse_position()
	var tile_mouse_pos :Vector2i = tile_map.local_to_map(mouse_pos)
	tile_map.erase_cell(world.interaction_layer , tile_mouse_pos)
	
	
func set_tile_map(map):
	tile_map = map
	
func set_world(wrld):
	world = wrld

func set_interaction_ui_reference(ui, label):
	interaction_ui = ui
	interaction_label = label

# Sets the player reference for inventory interactions
func set_player_reference(player):
	player_node = player
	
	#var node = str(player_node.get_path()) + "/InteractionUI"
	#interaction_ui = get_node(node)
	#print(interaction_ui)

# Adds an item to the inventory, returns true if successful
func add_item(item):
	for i in range(inventory.size()):
		# Check if the item exists in the inventory and matches both type and effect
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("Item added", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("Item added", inventory)
			return true
	return false

# Removes an item from the inventory based on type and effect
func remove_item():
	inventory_updated.emit()

# Increase inventory size dynamically
func increase_inventory_size():
	inventory_updated.emit()

