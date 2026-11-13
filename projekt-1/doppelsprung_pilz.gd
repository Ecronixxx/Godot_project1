extends Area2D
var respawn_point: Vector2 = Vector2(2625, -100)
var respawn_point_2 : Vector2 = Vector2(4800,-400)

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	body.sprungzahl += 1
	if global_position == respawn_point or global_position == respawn_point_2:
		body.sprungzahl = 0
	
		
