extends Node

var objets = []
# Called when the node enters the scene tree for the first time.
var objects_ready = false

func _ready():
	objets = [
	  {
		"name": "Houe",
		"icon": "res://Sprites/houe.png",
		"id": "houe",
		"effect": "rien",
		"use": "dirt",
		"type" : "tool",
		"quantity": 1
	  },
	  {
		"name": "Hache",
		"id": "hache",
		"groups": [
		  "tool"
		],
		"icon": "res://Sprites/hache.png",
		"effect": "rien",
		"use": "cut_tree",
		"type" : "tool",
		"quantity": 1
	  },
	  {
		"name": "Bois",
		"id": "wood",
		"groups": [
		  "material"
		],
		"icon": "res://Sprites/wood.png",
		"effect": "rien",
		"use": "rien",
		"type" : "material",
		"quantity": 1
	  },
	{
		"name": "Arbre",
		"id": "arbre",
		"groups": [
		  "tree"
		],
		"grow_steps": 5,
		"time_for_steps": 1,
		"final_object": "carotte",
		"seed": "carotte_seed",
		"grow_texture": "res://Sprites/carottes.png",
		"icon": "res://Sprites/carotte_seed.png",
		"etapes_sprites_arr": [[16, 0, 16, 16], [64, 0, 16, 16], [0, 16, 16, 16], [32, 0, 16, 32], [48, 0, 16, 32]],
		"etapes_position_y_arr": [8,8,8,0,0],
		"effect": "rien",
		"use": "plant",
		"type" : "food",
		"quantity": 1
	  },
	  {
		"name": "Plant de Carottes",
		"id": "carotte_plant",
		"groups": [
		  "seeds"
		],
		"grow_steps": 5,
		"time_for_steps": 1,
		"final_object": "carotte",
		"seed": "carotte_seed",
		"grow_texture": "res://Sprites/carottes.png",
		"icon": "res://Sprites/carotte_seed.png",
		"etapes_sprites_arr": [[16, 0, 16, 16], [64, 0, 16, 16], [0, 16, 16, 16], [32, 0, 16, 32], [48, 0, 16, 32]],
		"etapes_position_y_arr": [8,8,8,0,0],
		"effect": "rien",
		"use": "plant",
		"type" : "food",
		"quantity": 1
	  },
	  {
		"name": "Carotte",
		"id": "carotte",
		"groups": [
		  "consommable",
		  "food"
		],
		"effect": "Aucun",
		"use": "consommer",
		"type": "legume",
		"quantity": 1,
		"icon": "res://Sprites/icon_carottes.png"
	  },
	  {
		"name": "Grains de ble",
		"id": "weat_plant",
		"groups": [
		  "seeds"
		],
		"grow_steps": 5,
		"time_for_steps": 1,
		"final_object": "ble",
		"seed": "carotte_seed",
		"grow_texture": "res://Sprites/weat.png",
		"icon": "res://Sprites/weat_seed.png",
		"etapes_sprites_arr": [[16, 0, 16, 16], [64, 0, 16, 16], [0, 16, 16, 16], [32, 0, 16, 32], [48, 0, 16, 32]],
		"etapes_position_y_arr": [8,8,8,0,0],
		"effect": "rien",
		"use": "plant",
		"type" : "food",
		"quantity": 1
	  },
	  {
		"name": "Ble",
		"id": "ble",
		"groups": [
		  "consommable",
		  "food"
		],
		"effect": "Aucun",
		"use": "consommer",
		"type": "legume",
		"quantity": 1,
		"icon": "res://Sprites/icon_weat.png"
	  }
	]

	#for item in get_tree().get_nodes_in_group("inventory_item"):
		#item.objects_ready = true
	Global.objects_ready = true
	objects_ready = true
