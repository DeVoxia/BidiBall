extends Node2D

@onready var spawner := $Spawner
@onready var ui := $UI

func _ready():
    randomize()

# Exemple de callback "bac" (connecte body_entered de chaque Sink* vers ces méthodes)
func _on_SinkRed_body_entered(body):
    if body.has_variable("ball_color"):
        print("Red sink got:", body.ball_color)

func _on_SinkGreen_body_entered(body):
    if body.has_variable("ball_color"):
        print("Green sink got:", body.ball_color)

func _on_SinkBlue_body_entered(body):
    if body.has_variable("ball_color"):
        print("Blue sink got:", body.ball_color)

# Sera rempli à l'Étape 3
func _reset_game():
    pass
