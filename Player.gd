extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		rotation_degrees = 90
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		rotation_degrees = 270
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		rotation_degrees = 180
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		rotation_degrees = 0
		velocity.y -= 1
	if (Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right")):
		velocity.x += 1
		velocity.y -= 1
		rotation_degrees = 45
	if (Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left")):
		velocity.x -= 1
		velocity.y -= 1
		rotation_degrees = 315
	if (Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right")):
		velocity.x += 1
		velocity.y += 1
		rotation_degrees = 135
	if (Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left")):
		velocity.x -= 1
		velocity.y += 1
		rotation_degrees = 225
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
#		$AnimatedSprite2D.flip_v = false # this is awful dynamics
	# See the note below about boolean assignment.
#		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
#		$AnimatedSprite2D.flip_v = velocity.y > 0


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	hide() # player dissapears on contact
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
