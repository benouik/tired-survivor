### Inventory_Item.gd
@tool
extends Node2D

# Item details for editor window
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
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
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		#player_in_range = true
		#body.interact_ui.visible = true
		pickup_item()
		
# If player is in range, hide UI and don't make item pickable
func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		body.interact_ui.visible = false


func _on_area_2d_mouse_entered():
	player_in_range = true
	Global.interaction_ui.visible = true
	Global.interaction_label.visible = true
	Global.interaction_label.text = self.item_name
	Global.item_to_pickup = self
	print("entered")

func _on_area_2d_mouse_exited():
	player_in_range = false
	if Global.item_to_pickup == self:
		Global.interaction_ui.visible = false
		Global.interaction_label.visible = false
		Global.item_to_pickup = Node2D


