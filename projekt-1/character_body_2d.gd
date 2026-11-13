extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -350
var on_ladder: bool = false
var gravity: float = 0

@onready var player_sprite = $AnimatedSprite2D
@onready var punkte_label = $"../CanvasLayer/Control/Label"

# 🟢 Startposition beim Spielstart
var start_point: Vector2 = Vector2(-150, -80)

# 🟢 Respawn-Position nach dem Tod oder nach Checkpoint
var respawn_point: Vector2 = Vector2(2625, -100)
var respawn_point_2 : Vector2 = Vector2(4800,-400)

# ✅ Checkpoint-Status
var checkpoint_reached: bool = false
var platform_4_reached: bool = true
var punkte = 0
var checkpoint_2_reached: bool = false
var spikes_enterred: bool = true
var respawnpoint
var sprungzahl = 1
var spruenge_verbraucht = 0
var leben = 10
func _ready() -> void:
	player_sprite.flip_h = true
	global_position = start_point
func _physics_process(delta: float) -> void:
	if leben <= 0:
		global_position = respawn_point
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		spruenge_verbraucht = 0

# Springen (auch in der Luft)
	if Input.is_action_just_pressed("ui_accept") and spruenge_verbraucht < sprungzahl:
		velocity.y = JUMP_VELOCITY
		spruenge_verbraucht += 1

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		player_sprite.play("laufen")
		velocity.x = direction * SPEED
		player_sprite.flip_h = velocity.x > 0
	else:
		player_sprite.play("ruhe")
		velocity.x = 0

	move_and_slide()
	# wenn du NICHT auf der Leiter bist → normale Physik
	if on_ladder:
		# Keine Schwerkraft
		velocity.y = 0
		
		if Input.is_action_pressed("ui_up"):
			velocity.y = -100
		elif Input.is_action_pressed("ui_down"):
			velocity.y = 100
		else:
			velocity.y += gravity * delta
		# Normale Schwerkraft
		move_and_slide()


# 💀 Wenn der Spieler stirbt → zurücksetzen

func _on_area_2d_body_entered(_body: Node2D) -> void:
	# Reihenfolge ist wichtig!
	if checkpoint_2_reached:
		global_position = respawn_point_2
	elif checkpoint_reached:
		global_position = respawn_point
	else:
		global_position = start_point
	
	velocity = Vector2.ZERO

# 🏁 Wird ausgelöst, wenn Spieler den Checkpoint erreicht
# ⚙️ Diese Funktion MUSS mit deinem Checkpoint-Signal verbunden sein
#    z. B. "Checkpoint1" → body_entered(body: Node2D)
func _on_checkpoint_1_body_entered(body: Node2D) -> void:
	if body == self:
		checkpoint_reached = true
		print("✅ Checkpoint erreicht!")


func _on_leiter_1_body_entered(body: Node2D) -> void:
	body.on_ladder = true



func _on_leiter_1_body_exited(body: Node2D) -> void:
	body.on_ladder= false


func _on_leiter_2_body_entered(body: Node2D) -> void:
	body.on_ladder = true


func _on_leiter_2_body_exited(body: Node2D) -> void:
	body.on_ladder = false
 


func _on_platform_4_body_entered(body: Node2D) -> void:
	print("zerquetscht")
	if platform_4_reached:
		global_position = respawn_point

func _process(delta: float) -> void:
	punkte_label.text = str(punkte)
	if leben <= 0:
		global_position = respawn_point
		leben = 10


func _on_checkpoint_2_body_entered(body: Node2D) -> void:
		if body == self:
			checkpoint_2_reached = true
			print(" Checkpoint 2 erreicht!")


func _on_spikes_body_entered(body: Node2D) -> void:
	if spikes_enterred:
		global_position = respawn_point 


func _on_gegner_body_entered(body: Node2D) -> void:
	leben -= 1
