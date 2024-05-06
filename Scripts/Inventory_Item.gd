### Inventory_Item.gd
@tool
extends Node2D

# Item details for editor window
#@export var item_type = ""
#@export var item_name = ""
#@export var item_texture: Texture
#@export var item_effect = ""

var ramassable = false
var etapes = 5
var scene_path: String = "res://Scenes/Inventory_Item.tscn"
#@onready var icon_texture = $Icon.texture
# Scene-Tree Node references
@onready var icon_sprite = $Sprite2D


var id = ""

# Variables
var player_in_range = false
var item: Dictionary


func _ready():
	
	


	#item_name = ["Fraise", "Melon", "Cerise"].pick_random()
	#item_effect = ["Sante", "Vitesse", "Energie"].pick_random()
	#print(Objets.objets)
	print("item id: " + id)
	
	for i in range(Objets.objets.size()):
		#print("id :" + str(id))
		#print(Objets.objets[i]["id"])
		if Objets.objets[i]["id"] == id:
			item = Objets.objets[i]
		
	#print("item: " + str(item))

	for group in item["groups"]:
		self.add_to_group(group)
		
	
	
	
	if self.is_in_group("seeds"):
		var texture = AtlasTexture.new()
		texture.set_atlas(load(item["grow_texture"]))
		$Sprite2D.texture = texture
		
		#var etapes_sprites_arr = [Rect2(16, 0, 16, 16), Rect2(64, 0, 16, 16), Rect2(0, 16, 16, 16), Rect2(32, 0, 16, 32), Rect2(48, 0, 16, 32)]
		#var etapes_position_y_arr = [8,8,8,0,0]
		
		var i = 0
		for etape in item["etapes_sprites_arr"]:

			icon_sprite.texture.region = Rect2(Vector2(etape[0], etape[1]), Vector2(etape[2], etape[3]))
			icon_sprite.position.y = item["etapes_position_y_arr"][i]
			i += 1
			await get_tree().create_timer(item["time_for_steps"]).timeout
		
		ramassable = true

# Add item to inventory
func pickup_item():
	
	#var item = {
		#"quantity": 1,
		#"name": item["name"],
		#"effect": item["effect"],
		#"texture": load(item["icon"]), #item_texture,
		#"scene_path": scene_path
	#}
	if Global.player_node:
		
		for i in range(Objets.objets.size()):
			if Objets.objets[i]["id"] == item["final_object"]:
				item = Objets.objets[i]
		
		Global.add_item(item)
		#Global.add_item(item, true)
		self.queue_free()
		if Global.item_to_pickup == self:
			Global.item_to_pickup = Node2D
			Global.interaction_ui.visible = false
			Global.interaction_label.visible = false
		

# If player is in range, show UI and make item pickable
#func _on_area_2d_body_entered(body):
	#if body.is_in_group("Player"):
		##player_in_range = true
		##body.interact_ui.visible = true
		#pickup_item()
		
# If player is in range, hide UI and don't make item pickable
#func _on_area_2d_body_exited(body):
	#if body.is_in_group("Player"):
		#player_in_range = false
		#body.interact_ui.visible = false


func _process(_delta):
	pass

func _on_area_2d_mouse_entered():
	#player_in_range = true
	Global.interaction_ui.visible = true
	Global.interaction_label.visible = true
	Global.interaction_label.text = self.item["name"]
	Global.can_plante = false
	#Global.item_to_pickup = self
	#print("entered")

func _on_area_2d_mouse_exited():
	#player_in_range = false
	#if Global.item_to_pickup == self:
		#Global.interaction_ui.visible = false
		#Global.interaction_label.visible = false
		#Global.item_to_pickup = Node2D
	Global.interaction_ui.visible = false
	Global.interaction_label.visible = false
	Global.can_plante = true



func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		if self.is_in_group("seeds") and ramassable:
			Global.remove_seed_tile_at_cursor()
			Global.can_plante = true
		#print(event.button_index)
		#print("lol it works")
		if ramassable:
			pickup_item()
			Global.interaction_ui.visible = false
			Global.interaction_label.visible = false
