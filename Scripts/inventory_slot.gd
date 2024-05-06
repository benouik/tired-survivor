extends Control


@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var detail_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var outer_border = $OuterBorder
#@onready var sprite = $Sprite2D

# L'objet que contient le Slot
var item = null
# L'index de l'inventaire lié à ce slot
var slot_index: int

# Appelé quand on clique droite sur le Slot, ou qu'on relache
signal drag_start(slot)
signal drag_end()

# On assigne l'index de l'inventaire à ce slot
func set_slot_index(new_index):
	slot_index = new_index

# On affiche le panneau de détails quand on survole le slot avec la souris et inversement, s'il contient un objet
func _on_item_button_mouse_entered():
	if item != null:
		#usage_panel.visible = false
		detail_panel.visible = true
	#print("Mouse entrée")

#func block(item):
	#if item != self:
		#blocked = !blocked
	#
		#if blocked:
			#$ItemButton.disabled = true
			#$ItemButton.visible = false
		#else:
			#$ItemButton.disabled = false
			#$ItemButton.visible = true

# On cache le volet de détails quand la souris ne le survole plus
func _on_item_button_mouse_exited():
	if item != null:
		detail_panel.visible = false

# Si on clique sur le slot on affiche le menu
func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible
		#get_tree().call_group("inventory_slots", "block", self)

# Si le slot ne contient pas d'objet, pas d'icone ni d'indication de quantité
func set_empty():
	icon.texture = null
	quantity_label.text = ""
	
# On attribue les élements d'interface à partir des valeurs de l'objet
func set_item(new_item):
	item = new_item
	icon.texture = load(item["icon"])
	#icon.texture.region = Rect2(64, 16, 16, 16)
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""


# Si on clique sur le slot
func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		#print(event.button_index)
		#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			#if item != null:
				#usage_panel.visible = !usage_panel.visible
		# Handle right mouse button for drag
		
		# Afin de dépacer le contenu d'un slot vers un autre
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
