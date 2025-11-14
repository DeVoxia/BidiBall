extends Node2D
@export var ball_scene: PackedScene
@export var spawn_point := Vector2(270, 80)  # ajuster au dessus de la 1ère vanne
@export var colors := ["Red","Green","Blue"]

func _ready():
    if has_node("Timer"):
        $"Timer".timeout.connect(_on_timeout)

func _on_timeout():
    if ball_scene == null:
        return
    var b = ball_scene.instantiate()
    b.global_position = spawn_point
    b.ball_color = colors[randi() % colors.size()]
    get_tree().current_scene.add_child(b)
