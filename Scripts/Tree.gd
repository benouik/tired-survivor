extends StaticBody2D


@onready var explosion = $GPUParticles2D
@onready var sprite = $Sprite2D

var hp = 5
var id = "wood"



func hit():
	hp -= 1
	if hp <= 0:
		
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate:a", 0, 0.3)
		self.collision_layer = 0
		
		explosion.emitting = true
		#sprite.visible = false
		
		
		for i in range(Objets.objets.size()):
			#print("id :" + str(id))
			#print(Objets.objets[i]["id"])
			if Objets.objets[i]["id"] == id:
				var item = Objets.objets[i]
				Global.add_item(item)
				break
		
		await get_tree().create_timer(2).timeout
		self.queue_free()
		print("pu d'arbre")
		
#		tween.set_parallel(true)
#		var shader_color = $Sprite2D.material.get_shader_parameter("hit_color")

	else:
		var tween2 = get_tree().create_tween()
		for i in range(5):
			tween2.tween_property(sprite, "skew", 0, 0.015)
			tween2.tween_property(sprite, "skew", 0, 0.015)
			tween2.tween_property(sprite, "skew", 0.1, 0.015)
			tween2.tween_property(sprite, "skew", 0, 0.015)
			tween2.tween_property(sprite, "skew", -0.1, 0.015)
			tween2.tween_property(sprite, "skew", 0, 0.015)

