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
var hotbar_size = 5
var hotbar = []
var can_plante: bool = true
var grabbed_slot: int
var receiving_slot: int
# Custom signals
signal inventory_updated

var item_to_pickup = Node2D
var world: Node2D

var tool_on_hand = null

@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")


func _ready(): 
	# Initializes the inventory with 30 slots (spread over 9 blocks per row)
	inventory.resize(24)
	hotbar.resize(hotbar_size)
	
func add_to_hotbar(inv_id):
	for i in range(hotbar.size()):
		if hotbar[i] == null:
			hotbar[i] = { "id": inv_id, "object": inventory[inv_id]["object"]}
			return true
	return false

func is_in_hotbar(inv_id):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]['id'] == inventory[inv_id]["id"]:
			return true
	return false

func update_hotbar_quantity(inv_id, value):
	for i in range(hotbar.size()):
		if hotbar[i]["id"] == inventory[inv_id]["id"]:
			hotbar[i]["object"]["quantity"] += value
			return true
	return false

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
func add_item(item, to_hotbar=false):
	
	var added_to_hotbar = false

	#if to_hotbar:
		#added_to_hotbar = add_to_hotbar(item)
		#inventory_updated.emit()
	
	if not added_to_hotbar:
		for i in range(inventory.size()):
			# Check if the item exists in the inventory and matches both type and effect
			if inventory[i] != null and inventory[i]["object"]["id"] == item["id"]: # inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
				inventory[i]["object"]["quantity"] += 1 #item["quantity"]
				#if is_in_hotbar(i):
					#pass
					##update_hotbar_quantity(i, 1) # item["quantity"])
				#else:
					#add_to_hotbar(i)
				inventory_updated.emit()
				print("Item updated", inventory)
				return true
		for i in range(inventory.size()):
			if inventory[i] == null:
				inventory[i] = {"id": i, "object": item}
				inventory_updated.emit()
				print("Item added", inventory)
				#if to_hotbar:
				#add_to_hotbar(i)
				inventory_updated.emit()
				return true
		return false

# Removes an item from the inventory based on type and effect
func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func remove_from_hotbar(item_type, item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			if hotbar[i]["quantity"] <= 0:
				hotbar[i] = null
			inventory_updated.emit()
			return true
	return false
		

# Increase inventory size dynamically
func increase_inventory_size():
	inventory_updated.emit()

# Swaps items in the inventory based on their indices
func swap_inventory_items(index1, index2):
	if index1 < 0 or index1 >= inventory.size() or index2 < 0 or index2 >= inventory.size():
		return false
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	

