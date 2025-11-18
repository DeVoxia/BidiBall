extends Node2D

# Scène de bille à instancier
@export var ball_scene: PackedScene

# Couleurs possibles
@export var colors := ["Red", "Green", "Blue"]

# Modes de déplacement
@export_enum("STATIC", "RANDOM") var move_mode := "RANDOM"

# Limites horizontales (en pixels, dans le repère global)
@export var left_limit_x: float = 40.0
@export var right_limit_x: float = 500.0

# Vitesse de déplacement en pixels/sec
@export var move_speed: float = 180.0

@onready var drop_point := $DropPoint
@onready var timer := $Timer

var _target_x: float

func _ready() -> void:
	randomize()
	_pick_new_target()

	if timer:
		# Assure-toi que le Timer a Autostart = true et One Shot = false
		timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	if move_mode == "RANDOM":
		_move_random(delta)

func _move_random(delta: float) -> void:
	# Avance vers la cible _target_x
	var dx = _target_x - position.x
	if abs(dx) < 2.0:
		# Une fois proche de la cible, on choisit un nouveau X
		_pick_new_target()
	else:
		var dir = sign(dx)
		position.x += dir * move_speed * delta

func _pick_new_target() -> void:
	# Nouveau X aléatoire entre les limites
	_target_x = randf_range(left_limit_x, right_limit_x)

func _on_timer_timeout() -> void:
	if ball_scene == null:
		return

	var ball = ball_scene.instantiate()
	ball.global_position = drop_point.global_position

	# Couleur logique si la bille gère ball_color
	if ball.has_variable("ball_color"):
		var color_name = colors[randi() % colors.size()]
		ball.ball_color = color_name
		if ball.has_method("_apply_color"):
			ball._apply_color()

	get_tree().current_scene.add_child(ball)
