### Inventory_Item.gd
@tool
extends Node2D

var ramassable = false
var etapes = 5
var scene_path: String = "res://Scenes/Inventory_Item.tscn"
#@onready var icon_texture = $Icon.texture
# Scene-Tree Node references
@onready var icon_sprite = $Sprite2D


var id = ""
var objects_ready = false

# Variables
var player_in_range = false
var item: Dictionary


func _ready():
	
	print(get_tree())
	while not self.is_inside_tree():
		print("not ready")
	while not Objets.get("objects_ready"):
		await get_tree().create_timer(1).timeout
		
	while not Objets.objects_ready:
		await get_tree().create_timer(1).timeout

	for i in range(Objets.objets.size()):
		#print("id :" + str(id))
		#print(Objets.objets[i]["id"])
		if Objets.objets[i].id == id:
			item = Objets.objets[i]
	#print("item: " + str(item))

	for group in item.groups:
		self.add_to_group(group)
		
	
	
	
	if self.is_in_group("seeds"):
		var texture = AtlasTexture.new()
		texture.set_atlas(load(item.grow_texture))
		$Sprite2D.texture = texture
		
		#var etapes_sprites_arr = [Rect2(16, 0, 16, 16), Rect2(64, 0, 16, 16), Rect2(0, 16, 16, 16), Rect2(32, 0, 16, 32), Rect2(48, 0, 16, 32)]
		#var etapes_position_y_arr = [8,8,8,0,0]
		
		var i = 0
		for etape in item.etapes_sprites_arr:

			icon_sprite.texture.region = Rect2(Vector2(etape[0], etape[1]), Vector2(etape[2], etape[3]))
			icon_sprite.position.y = item.etapes_position_y_arr[i]
			i += 1
			await get_tree().create_timer(item.time_for_steps).timeout
		
		ramassable = true

# Add item to inventory
func pickup_item():
	var pickup_object
	
	var item2
	if self.is_in_group("seeds"):
		if ramassable:
			pickup_object = item.final_object
			for i in range(Objets.objets.size()):
				if Objets.objets[i].id == pickup_object:
					item2 = Objets.objets[i]
			
			Global.add_item(item2)
			
		#else:
		pickup_object = item.id
			
	if Global.player_node:
		for i in range(Objets.objets.size()):
			if Objets.objets[i].id == pickup_object:
				item = Objets.objets[i]
		
		Global.add_item(item)
		#Global.add_item(item, true)
		self.queue_free()
		if Global.item_to_pickup == self:
			Global.item_to_pickup = Node2D
			Global.interaction_ui.visible = false
			Global.interaction_label.visible = false
			


func _on_area_2d_mouse_entered():
	Global.interaction_ui.visible = true
	Global.interaction_label.visible = true
	Global.interaction_label.text = item.name

func _on_area_2d_mouse_exited():
	Global.interaction_ui.visible = false
	Global.interaction_label.visible = false



func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		var _pos = Global.world.to_local(position)
		#print(pos)
		if self.is_in_group("seeds"):
			Global.can_plante = false
			#await get_tree().create_timer(0.3).timeout
			#Global.can_plante = true
		if event.pressed and event.button_index == 2:
			if self.is_in_group("seeds"):
				Global.remove_seed_tile_at_cursor()
				#Global.can_plante = true
		#print(event.button_index)
		#print("lol it works")
			pickup_item()
			Global.interaction_ui.visible = false
			Global.interaction_label.visible = false
