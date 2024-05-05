extends Control


@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var detail_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel



var item = null
var blocked: bool = false
var slot_index = -1

func set_slot_index(new_index):
	slot_index = new_index

func _on_item_button_mouse_entered():
	if item != null and not blocked:
		#usage_panel.visible = false
		detail_panel.visible = true
	#print("Mouse entrée")

func block(item):
	if item != self:
		blocked = !blocked
	
		if blocked:
			$ItemButton.disabled = true
			$ItemButton.visible = false
		else:
			$ItemButton.disabled = false
			$ItemButton.visible = true

func _on_item_button_mouse_exited():
	if item != null:
		detail_panel.visible = false


func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible
		get_tree().call_group("inventory_slots", "block", self)

func set_empty():
	icon.texture = null
	quantity_label.text = ""
	
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
	

