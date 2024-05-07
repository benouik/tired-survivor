extends Node


# Liste des objets possibles de l'inventaire
var objets = [
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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

