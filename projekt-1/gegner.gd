extends Area2D
#
var vorherige_position = position
@onready var animated_sprite_2d:  AnimatedSprite2D = $AnimatedSprite2D



func _on_body_entered(body: Node2D) -> void:
	body.leben -= 1
func _process(delta: float) -> void:
	if position.x > vorherige_position.x:
		animated_sprite_2d.flip_h = true
	elif position.x < vorherige_position.x:
		animated_sprite_2d.flip_h = false
	vorherige_position = position
