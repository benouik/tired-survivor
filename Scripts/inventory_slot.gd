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
# Le slot est sélectionné
var slot_is_active = false

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

# On cache le volet de détails quand la souris ne le survole plus
func _on_item_button_mouse_exited():
	if item != null:
		detail_panel.visible = false


# Si le slot ne contient pas d'objet, pas d'icone ni d'indication de quantité
func set_empty():
	icon.texture = null
	quantity_label.text = ""
	if slot_is_active:
		outer_border.color = "8625fe"

# On attribue les élements d'interface à partir des valeurs de l'objet
func set_item(_item):
	#icon.texture = load(item["object"]["icon"])
	icon.texture = load(_item.object.icon)
	#icon.texture.region = Rect2(64, 16, 16, 16)
	quantity_label.text = str(_item.quantity)
	item_name.text = str(_item.object.name)
	item_type.text = str(_item.object.type)
	if _item.object.effect != "":
		item_effect.text = str(_item.object.effect)
	else:
		item_effect.text = ""
		
	if slot_is_active:
		outer_border.color = "8625fe"


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
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if slot_index < 5:
					Global.set_item_in_hand(slot_index)
