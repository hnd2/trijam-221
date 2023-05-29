extends CharacterBody2D

enum PlayerState {
	STAND,
	DOWN,
	DEAD,
}

@export var speed = 300.0
@export var jump_speed = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = PlayerState.STAND

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(PlayerState.STAND)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2.ZERO
	if state == PlayerState.STAND:
		if Input.is_action_pressed("move_left"):
			direction.x -= 1.0
		if Input.is_action_pressed("move_right"):
			direction.x += 1.0
	velocity.x = direction.x * speed
	
	if is_on_floor():
		if state == PlayerState.STAND && Input.is_action_just_pressed("jump"):
			set_state(PlayerState.DOWN)
			velocity.y = 0
		elif state == PlayerState.DOWN && Input.is_action_just_released("jump"):
			set_state(PlayerState.STAND)
			velocity.y = jump_speed
			$AudioJump.play()
		else:
			velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	move_and_slide()

func apply_force(force):
	if is_on_floor():
		velocity = force
		set_state(PlayerState.DEAD)
		var normal = get_floor_normal()
		rotation = normal.angle()
		move_and_slide()

func set_state(new_state):
	state = new_state
	
	if state == PlayerState.STAND:
		$AnimatedSprite2D.play("default")
	elif state == PlayerState.DOWN:
		$AnimatedSprite2D.play("down")
	elif state == PlayerState.DEAD:
		$AnimatedSprite2D.play("dead")
