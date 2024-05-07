extends Control


@onready var grid_container = $GridContainer

var dragged_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_inventory_ui(grid_container)
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()



# Appelé à chaque mise à jour de l'inventaire
func _on_inventory_updated():
	
	# On reset tout
	clear_grid_container()
	
	# On repeuple les slots de l'inventaire avec les éléments présents dans l'inventaire
	# (Les premiers slots de l'inventaire sont la hotbar dont on les zappe)
	for i in range(5, Global.inventory.size()):
		var item = Global.inventory[i]
		var slot = Global.inventory_slot_scene.instantiate()
		
		# Chaque slot est connecté à son propre signal ?
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		grid_container.add_child(slot)
		
		# On assigne à chaque slot un index qui est celui de sa place dans l'inventaire
		slot.set_slot_index(i)
		
		# Si l'inventaire est vide pour cette index on crée un slot vide, sinon on y attribue l'objet de l'inventaire
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	
	
# Efface tous les slots de l'interface de l'inventaire
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()


# Appelé quand on clique droite sur un slot d'inventaire
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("Drag started for slot:", slot_control)


# Appelé quand le clic droit est relaché
func _on_drag_end():
	var target_slot = Global.get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		Global.drop_slot(dragged_slot, target_slot)
	dragged_slot = null
