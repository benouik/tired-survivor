extends Control


@onready var hotbar_container = $HBoxContainer

var dragged_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_hotbar_ui(hotbar_container)
	Global.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

func _update_hotbar_ui():
	clear_hotbar_container()
	for i in range(Global.hotbar.size()):
		var slot = Global.inventory_slot_scene.instantiate()
		#slot.set_slot_index(i)
		
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		hotbar_container.add_child(slot)
		
		slot.set_slot_index(i)
		
		if Global.inventory[i] != null:
			slot.set_item(Global.inventory[i]["object"])
		else:
			slot.set_empty()
		
		

func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()
		
		
#func get_slot_under_mouse() -> Control:
	#var mouse_position = get_global_mouse_position()
	#for slot in hotbar_container.get_children():
		#var slot_rect = Rect2(slot.global_position, slot.size)
		#if slot_rect.has_point(mouse_position):
			#return slot
	#return null
# Drop slots

func drop_slot(slot1: Control, slot2: Control):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		return  
	else:
		if Global.swap_inventory_items(slot1_index, slot2_index):
			_update_hotbar_ui()
			print("Dropping slots:", slot1_index, slot2_index)
			
# Find the index of a slot
func get_slot_index(slot: Control) -> int:
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) == slot:
			# Valid slot
			return i
	# Invalid slot
	return -1 
	
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("Drag started for slot:", slot_control)

# Drops slot at new location
func _on_drag_end():
	var target_slot = Global.get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		Global.drop_slot(dragged_slot, target_slot)
	dragged_slot = null
