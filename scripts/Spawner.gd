extends Node2D

@export var ball_scene: PackedScene

@export_enum("STATIC", "RANDOM") var move_mode := "RANDOM"
@export var left_limit_x: float = 40.0
@export var right_limit_x: float = 500.0
@export var move_speed: float = 180.0

@onready var drop_point := $DropPoint
@onready var timer := $Timer

var _target_x: float

func _ready() -> void:
	randomize()
	_pick_new_target()

	if timer:
		if not timer.timeout.is_connected(_on_timer_timeout):
			timer.timeout.connect(_on_timer_timeout)
		print("Spawner READY. ball_scene =", ball_scene,
			" path =", ball_scene.resource_path if ball_scene else "NONE")

func _process(delta: float) -> void:
	if move_mode == "RANDOM":
		_move_random(delta)

func _move_random(delta: float) -> void:
	var dx = _target_x - position.x
	if abs(dx) < 2.0:
		_pick_new_target()
	else:
		var dir = sign(dx)
		position.x += dir * move_speed * delta

func _pick_new_target() -> void:
	_target_x = randf_range(left_limit_x, right_limit_x)

func _on_timer_timeout() -> void:
	if ball_scene == null:
		push_error("⚠ ball_scene est NULL dans Spawner !")
		return

	var ball = ball_scene.instantiate()
	ball.global_position = drop_point.global_position

	print("Instancié :", ball, " classe =", ball.get_class())

	get_tree().current_scene.add_child(ball)
