extends Node2D

@export var camera: Camera2D
@export var floor: PackedScene

enum GameState {
	TITLE,
	PLAYING,
	GAMEOVER,
}

var fall_speed = 1.2
var fall_velocity_y = 0.0
var num_floors = 30
var state = GameState.TITLE
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	make_floor()
	set_state(GameState.TITLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if state == GameState.TITLE:
		if Input.is_action_just_pressed("jump"):
			set_state(GameState.PLAYING)
			$GameStartTimer.start()
	elif state == GameState.PLAYING && playing:
		# move floor
		fall_velocity_y += fall_speed * delta
		$FloorRoot.position.y -= fall_velocity_y
		if $FloorRoot.position.y <= 0:
			$FloorRoot.position.y = 0
			var direction = Vector2.UP.rotated(randf_range(-PI / 4, PI / 4))
			$Player.apply_force(direction * 10000.0)
			set_state(GameState.GAMEOVER)
		shake()
	elif state == GameState.GAMEOVER && playing:
		if Input.is_action_just_pressed("jump"):
			get_tree().reload_current_scene()

func set_state(new_state):
	state = new_state
	
	if new_state == GameState.TITLE:
		reset()
		$FloorRoot.visible = false
		$CanvasLayer.show()
		playing = false
	elif new_state == GameState.PLAYING:
		reset()
		$FloorRoot.visible = true
		$CanvasLayer.hide()
		playing = false
	elif new_state == GameState.GAMEOVER:
		$GameStartTimer.start()
		playing = false
		pass

func make_floor():
	for i in num_floors:
		var new_floor = floor.instantiate()
		new_floor.position.y = -i * 72
		new_floor.set_text("%sF" % (i + 1))
		$FloorRoot.add_child(new_floor)

func reset():
	$FloorRoot.position.y = (num_floors - 1) * 72

func shake():
	var scale = fall_velocity_y * 1.0
	var offset = Vector2(randf_range(-scale, scale), randf_range(-scale, scale))
	camera.offset = offset


func _on_game_start_timer_timeout():
	playing = true
	pass # Replace with function body.

