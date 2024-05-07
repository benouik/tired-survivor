extends Control


@onready var hotbar_container = $HBoxContainer

var dragged_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_hotbar_ui(hotbar_container)
	Global.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

# Appelé à chaque mise à jour de l'inventaire
func _update_hotbar_ui():
	
	# On reset tout
	clear_hotbar_container()
	
	# On repeuple les slots de la hobart avec les 5 premiers éléments présents dans l'inventaire
	for i in range(Global.hotbar.size()):
		var slot = Global.inventory_slot_scene.instantiate()
		
		# Chaque slot est connecté à son propre signal ?
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		hotbar_container.add_child(slot)
		
		# On assigne à chaque slot un index qui est celui de sa place dans l'inventaire
		slot.set_slot_index(i)
		
		if Global.item_in_hand == i:
			slot.slot_is_active = true
		
		# Si l'inventaire est vide pour cette index on crée un slot vide, sinon on y attribue l'objet de l'inventaire
		if Global.inventory[i] != null:
			slot.set_item(Global.inventory[i])
		else:
			slot.set_empty()

# Efface tous les slots de l'interface de la hotbar
func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()
		
# Appelé quand on clique droite sur un slot de hotbar
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("Drag started for slot:", slot_control)

# Drops slot at new location
func _on_drag_end():
	var target_slot = Global.get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		Global.drop_slot(dragged_slot, target_slot)
	dragged_slot = null
