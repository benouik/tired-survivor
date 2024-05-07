### Global.gd

extends Node

# Scene and node references
var player_node: Node = null
var interaction_ui: ColorRect = null
var interaction_label: Label = null

var cursor_active: bool = false
var tile_map: TileMap
var inventory_ui : Control
var hotbar_ui :Control
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

var item_in_hand:int  = 0


@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")


func _ready(): 
	# Initializes the inventory with 30 slots (spread over 9 blocks per row)
	inventory.resize(29)
	hotbar.resize(hotbar_size)
	
	var item

	for i in range(Objets.objets.size()):
		if Objets.objets[i]["id"] == "houe":
			item = Objets.objets[i]
			add_item(item)

	for i in range(Objets.objets.size()):
		if Objets.objets[i]["id"] == "carotte_plant":
			item = Objets.objets[i]
			add_item(item)
			
	for i in range(Objets.objets.size()):
		if Objets.objets[i]["id"] == "weat_plant":
			item = Objets.objets[i]
			add_item(item)
	inventory_updated.emit()

func cast_ray(start, target):
	var space_state = world.get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(start, target)
	query.set_collision_mask(2|4)
	query.exclude = [self]
	query.collide_with_areas = true
	query.hit_from_inside = true
	
	return space_state.intersect_ray(query)

func can_plant():
	var mouse_position :Vector2 = world.get_global_mouse_position()
	var tile_mouse_pos :Vector2i = tile_map.local_to_map(mouse_position)
	
	print(mouse_position)
	var data = cast_ray(Vector2(mouse_position.x -2, mouse_position.y -2), Vector2(mouse_position.x +2, mouse_position.y +2))
	if data and data.collider.get_parent().is_in_group("seeds"):
		print(data)
		return false
	return true
	#print(data)

func set_item_in_hand(i):
	item_in_hand = i
	inventory_updated.emit()
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

func update_item_quantity(id, value):
	if inventory[id] != null:
		inventory[id]["quantity"] += value
		if inventory[id]["quantity"] <= 0:
			inventory[id] = null
		inventory_updated.emit()
		return true
	return false

func remove_seed_tile_at_cursor():
	var mouse_pos :Vector2 = world.get_global_mouse_position()
	var tile_mouse_pos :Vector2i = tile_map.local_to_map(mouse_pos)
	tile_map.erase_cell(world.interaction_layer , tile_mouse_pos)
	
	
func get_slot_under_mouse() -> Control:
	#var mouse_position = world.world.get_global_mouse_position()
	var mouse_position = inventory_ui.get_global_mouse_position()
	
	print(mouse_position)
	for slot in inventory_ui.get_children():
		var slot_rect = Rect2(slot.global_position, Vector2(80, 80))
		print(slot_rect)
		if slot_rect.has_point(mouse_position):
			return slot
	mouse_position = hotbar_ui.get_global_mouse_position()
	for slot in hotbar_ui.get_children():
		var slot_rect = Rect2(slot.global_position, Vector2(80, 80))
		#print(slot_rect)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
func drop_slot(slot1: Control, slot2: Control):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		return  
	else:
		if swap_inventory_items(slot1_index, slot2_index):
			inventory_updated.emit()
			print("Dropping slots:", slot1_index, slot2_index)
			
# Find the index of a slot
func get_slot_index(slot: Control) -> int:
	for i in range(inventory_ui.get_child_count()):
		if inventory_ui.get_child(i) == slot:
			# Valid slot
			return i +5
	for i in range(hotbar_ui.get_child_count()):
		if hotbar_ui.get_child(i) == slot:
			# Valid slot
			return i
	# Invalid slot
	return -1
	

func set_tile_map(map):
	tile_map = map
	
func set_inventory_ui(ui):
	inventory_ui = ui

func set_hotbar_ui(ui):
	hotbar_ui = ui
	
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
func add_item(item, _to_hotbar=false):
	
	var added_to_hotbar = false

	#if to_hotbar:
		#added_to_hotbar = add_to_hotbar(item)
		#inventory_updated.emit()
	
	if not added_to_hotbar:
		for i in range(inventory.size()):
			# Check if the item exists in the inventory and matches both type and effect
			if inventory[i] != null and inventory[i]["object"]["id"] == item["id"]: # inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
				inventory[i]["quantity"] += 1 #item["quantity"]
				#if is_in_hotbar(i):
					#pass
					##update_hotbar_quantity(i, 1) # item["quantity"])
				#else:
					#add_to_hotbar(i)
				inventory_updated.emit()
				#print("Item updated", inventory)
				return true
		for i in range(inventory.size()):
			if inventory[i] == null:
				inventory[i] = {"id": i, "object": item, "quantity": 1}
				inventory_updated.emit()
				#print("Item added", inventory)
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
	

