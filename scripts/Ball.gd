extends RigidBody2D
@export var ball_color := "Green" # "Red" | "Green" | "Blue"

func _ready():
    _apply_color()

func _apply_color():
    var map = {
        "Red": Color(1,0,0),
        "Green": Color(0,1,0),
        "Blue": Color(0,0,1)
    }
    if has_node("Sprite2D"):
        $"Sprite2D".modulate = map.get(ball_color, Color.WHITE)

# un léger amorti pour éviter les rebonds sauvages
func _integrate_forces(state):
    linear_damp = 0.2
    angular_damp = 0.2
