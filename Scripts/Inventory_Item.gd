### Inventory_Item.gd
@tool
extends Node2D

# Item details for editor window
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
var ramassable = false
var etapes = 5
var scene_path: String = "res://Scenes/Inventory_Item.tscn"

# Scene-Tree Node references
@onready var icon_sprite = $Sprite2D

# Variables
var player_in_range = false

func _ready():
	# Set the texture to reflect in the game
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	item_name = ["Fraise", "Melon", "Cerise"].pick_random()
	item_effect = ["Sante", "Vitesse", "Energie"].pick_random()
	
	if self.is_in_group("seeds"):
		
		var etapes_sprites_arr = [Rect2(16, 0, 16, 16), Rect2(64, 0, 16, 16), Rect2(0, 16, 16, 16), Rect2(32, 0, 16, 32), Rect2(48, 0, 16, 32)]
		var etapes_position_y_arr = [8,8,8,0,0]
		var i = 0
		for etape in etapes_sprites_arr:

			$Sprite2D.texture.region = etape
			$Sprite2D.position.y = etapes_position_y_arr[i]
			i += 1
			await get_tree().create_timer(1.0).timeout
		
		ramassable = true

func _process(_delta):
	# Set the texture to reflect in the editor
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture

# Add item to inventory
func pickup_item():
	
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"effect": item_effect,
		"texture": item_texture,
		"scene_path": scene_path
	}
	if Global.player_node:
		Global.add_item(item)
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


func _on_area_2d_mouse_entered():
	#player_in_range = true
	Global.interaction_ui.visible = true
	Global.interaction_label.visible = true
	Global.interaction_label.text = self.item_name
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
	if  event is InputEventMouseButton and event.pressed and event.button_index == 2:
		if self.is_in_group("seeds") and ramassable:
			Global.remove_seed_tile_at_cursor()
			Global.can_plante = true
		#print(event.button_index)
		#print("lol it works")
		if ramassable:
			pickup_item()
			Global.interaction_ui.visible = false
			Global.interaction_label.visible = false
