extends RigidBody2D

# Couleurs possibles pour cette bille
@export var possible_colors := ["Red", "Green", "Blue"]

var ball_color: String
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    randomize()
    _pick_random_color()
    _apply_color()

func _pick_random_color() -> void:
    if possible_colors.is_empty():
        ball_color = "Red"
    else:
        var idx := randi() % possible_colors.size()
        ball_color = possible_colors[idx]

func _apply_color() -> void:
    var map := {
        "Red":   Color(1.0, 0.25, 0.25),
        "Green": Color(0.25, 1.0, 0.45),
        "Blue":  Color(0.30, 0.55, 1.0)
    }
    if sprite:
        sprite.modulate = map.get(ball_color, Color.WHITE)

func _integrate_forces(_state) -> void:
    linear_damp = 0.2
    angular_damp = 0.2
